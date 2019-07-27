--[[
	CHoldoutGameRound - A single round of Holdout
]]

if CHoldoutGameRound == nil then
	CHoldoutGameRound = class({})
end


function CHoldoutGameRound:ReadConfiguration( kv, gameMode, roundNumber )
	self._gameMode = gameMode
	self._nRoundNumber = roundNumber
	self._szRoundTitle = kv.round_title or string.format( "Round%d", roundNumber )

	self._nMaxGold = tonumber( kv.MaxGold or 0 )
	self._nBagCount = tonumber( kv.BagCount or 0 )
	self._nBagVariance = tonumber( kv.BagVariance or 0 )
	self._nFixedXP = tonumber( kv.FixedXP or 0 )

	self._vSpawners = {}
	for k, v in pairs( kv ) do
		if type( v ) == "table" and v.NPCName then
			local spawner = CHoldoutGameSpawner()
			spawner:ReadConfiguration( k, v, self )
			self._vSpawners[ k ] = spawner
		end
	end

	for _, spawner in pairs( self._vSpawners ) do
		spawner:PostLoad( self._vSpawners )
	end
end


function CHoldoutGameRound:Precache()
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Precache()
	end
end

function CHoldoutGameRound:Begin()
	self._vEnemiesRemaining = {}
	self._vEventHandles = {
		ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CHoldoutGameRound, "OnNPCSpawned" ), self ),
		ListenToGameEvent( "entity_killed", Dynamic_Wrap( CHoldoutGameRound, "OnEntityKilled" ), self ),
		ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CHoldoutGameRound, 'OnItemPickedUp' ), self ),
		ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CHoldoutGameRound, 'OnHoldoutReviveComplete' ), self )
	}

	self._vPlayerStats = {}
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		self._vPlayerStats[ nPlayerID ] = {
			nCreepsKilled = 0,
			nGoldBagsCollected = 0,
			nDeathsThisRound = 0,
			nPriorRoundDeaths = PlayerResource:GetDeaths( nPlayerID ),
			nPlayersResurrected = 0,
			nGoldFromBags = 0,
			nPotionsTaken = 0,
			nClutches = 0,
			nKillsWithoutDying = 0,
			nKillsInWindow = 0,
		}
	end

	self._nGoldRemainingInRound = self._nMaxGold
	self._nGoldBagsRemaining = self._nBagCount
	self._nGoldBagsExpired = 0
	self._nCoreUnitsTotal = 0
	self._nTowers = 0
	self._nTowersStanding = 0
	self._nTowersStandingGoldReward = 0
	self._nStarRanking = 0
	self._nTotalDeaths = 0
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Begin()
		self._nCoreUnitsTotal = self._nCoreUnitsTotal + spawner:GetTotalUnitsToSpawn()
	end
	self._nCoreUnitsKilled = 0
end


function CHoldoutGameRound:End()
	for _, eID in pairs( self._vEventHandles ) do
		StopListeningToGameEvent( eID )
	end
	self._vEventHandles = {}

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )) do
		if not unit:IsTower() then
			UTIL_RemoveImmediate( unit )
		end
	end

	for _,spawner in pairs( self._vSpawners ) do
		spawner:End()
	end

	self._nTowers = 0
	self._nTowersStanding = 0
	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false ) ) do
		if unit:IsTower() then
			self._nTowers = self._nTowers + 1
			if unit:IsAlive() then
				self._nTowersStanding = self._nTowersStanding + 1
			end
		end
	end
	self._nTowersStandingGoldReward = self._gameMode:ComputeTowerBonusGold( self._nTowers, self._nTowersStanding )
	
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			PlayerResource:ModifyGold( nPlayerID, self._nTowersStandingGoldReward, true, DOTA_ModifyGold_Unspecified )
		end
	end

	self:CalculateStarRanking()
	self._gameMode:_SendScoresToClient( true )
end


function CHoldoutGameRound:Think()
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Think()
	end
end


function CHoldoutGameRound:ChooseRandomSpawnInfo()
	return self._gameMode:ChooseRandomSpawnInfo()
end


function CHoldoutGameRound:IsFinished()
	for _, spawner in pairs( self._vSpawners ) do
		if not spawner:IsFinishedSpawning() then
			return false
		end
	end
	local nEnemiesRemaining = #self._vEnemiesRemaining
	if nEnemiesRemaining == 0 then
		return true
	end

	if not self._lastEnemiesRemaining == nEnemiesRemaining then
		self._lastEnemiesRemaining = nEnemiesRemaining
		print ( string.format( "%d enemies remaining in the round...", #self._vEnemiesRemaining ) )
	end
	return false
end


-- Rather than use the xp granting from the units keyvalues file,
-- we let the round determine the xp per unit to grant as a flat value.
-- This is done to make tuning of rounds easier.
function CHoldoutGameRound:GetXPPerCoreUnit()
	if self._nCoreUnitsTotal == 0 then
		return 0
	else
		return math.floor( self._nFixedXP / self._nCoreUnitsTotal )
	end
end


function CHoldoutGameRound:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:IsPhantom() or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:GetUnitName() == "" then
		return
	end

	if spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		spawnedUnit:SetMustReachEachGoalEntity(true)
		table.insert( self._vEnemiesRemaining, spawnedUnit )
		spawnedUnit:SetDeathXP( 0 )
		spawnedUnit.unitName = spawnedUnit:GetUnitName()
	end
end


function CHoldoutGameRound:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if not killedUnit then
		return
	end

	for i, unit in pairs( self._vEnemiesRemaining ) do
		if killedUnit == unit then
			table.remove( self._vEnemiesRemaining, i )
			break
		end
	end	
	if killedUnit.Holdout_IsCore then
		self._nCoreUnitsKilled = self._nCoreUnitsKilled + 1
		self:_CheckForGoldBagDrop( killedUnit )
		self._gameMode:CheckForLootItemDrop( killedUnit )
	end

	if killedUnit:IsRealHero() then
		print( "Hero died" )
		local nPlayerID = killedUnit:GetPlayerOwnerID()
		if PlayerResource:IsValidTeamPlayerID( nPlayerID ) then
			local playerStats = self._vPlayerStats[ nPlayerID ]
			if playerStats then
				print( "Added a death this round")
				playerStats.nDeathsThisRound = playerStats.nDeathsThisRound + 1
			end
		end
	end

	local attackerUnit = EntIndexToHScript( event.entindex_attacker or -1 )
	if attackerUnit then
		local playerID = attackerUnit:GetPlayerOwnerID()
		local playerStats = self._vPlayerStats[ playerID ]
		if playerStats then
			playerStats.nCreepsKilled = playerStats.nCreepsKilled + 1
		end
	end
end


function CHoldoutGameRound:OnHoldoutReviveComplete( event )
	local castingHero = EntIndexToHScript( event.caster )
	if castingHero then
		local nPlayerID = castingHero:GetPlayerOwnerID()
		local playerStats = self._vPlayerStats[ nPlayerID ]
		if playerStats then
			playerStats.nPlayersResurrected = playerStats.nPlayersResurrected + 1
		end
	end
end


function CHoldoutGameRound:OnItemPickedUp( event )
	if event.itemname == "item_bag_of_gold" then
		local playerStats = self._vPlayerStats[ event.PlayerID ]
		if playerStats then
			playerStats.nGoldBagsCollected = playerStats.nGoldBagsCollected + 1
		end
	end
end


function CHoldoutGameRound:_CheckForGoldBagDrop( killedUnit )
	if self._nGoldRemainingInRound <= 0 then
		return
	end

	local nGoldToDrop = 0
	local nCoreUnitsRemaining = self._nCoreUnitsTotal - self._nCoreUnitsKilled
	if nCoreUnitsRemaining <= 0 then
		nGoldToDrop = self._nGoldRemainingInRound
	else
		local flCurrentDropChance = self._nGoldBagsRemaining / (1 + nCoreUnitsRemaining)
		if RandomFloat( 0, 1 ) <= flCurrentDropChance then
			if self._nGoldBagsRemaining <= 1 then
				nGoldToDrop = self._nGoldRemainingInRound
			else
				nGoldToDrop = math.floor( self._nGoldRemainingInRound / self._nGoldBagsRemaining )
				nCurrentGoldDrop = math.max(1, RandomInt( nGoldToDrop - self._nBagVariance, nGoldToDrop + self._nBagVariance  ) )
			end
		end
	end
	
	nGoldToDrop = math.min( nGoldToDrop, self._nGoldRemainingInRound )
	if nGoldToDrop <= 0 then
		return
	end
	self._nGoldRemainingInRound = math.max( 0, self._nGoldRemainingInRound - nGoldToDrop )
	self._nGoldBagsRemaining = math.max( 0, self._nGoldBagsRemaining - 1 )

	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( nGoldToDrop )
	local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
	local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
	newItem:LaunchLoot( true, 300, 0.75, dropTarget )
end

function CHoldoutGameRound:ApplyVisionToRemainingEnemies()
	local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil then
				enemy:AddNewModifier( enemy, nil, "modifier_razor_link_vision", { duration = -1 } )
			end
		end
	end
end

function CHoldoutGameRound:OnGoldBagExpired()
	self._nGoldBagsExpired = self:GetGoldBagsExpired() + 1
end

function CHoldoutGameRound:GetRoundNumber()
	return self._nRoundNumber
end

function CHoldoutGameRound:GetRoundTitle()
	return self._szRoundTitle
end

function CHoldoutGameRound:GetRoundDescription()
	return ""
end

function CHoldoutGameRound:GetTotalTowers()
	return self._nTowers
end

function CHoldoutGameRound:GetTowersRemaining()
	return self._nTowersStanding
end

function CHoldoutGameRound:GetTowersStandingGoldReward()
	return self._nTowersStandingGoldReward
end

function CHoldoutGameRound:GetTotalUnits()
	return self._nCoreUnitsTotal
end

function CHoldoutGameRound:GetRemainingUnits()
	return #self._vEnemiesRemaining
end

function CHoldoutGameRound:GetTotalUnitsKilled()
	return self._nCoreUnitsKilled
end

function CHoldoutGameRound:GetPlayerStats( nPlayerID )
	return self._vPlayerStats[ nPlayerID ]
end

function CHoldoutGameRound:GetStarRanking()
	return self._nStarRanking
end

function CHoldoutGameRound:GetTotalDeaths()
	return self._nTotalDeaths 
end

function CHoldoutGameRound:GetGoldBagsExpired()
	return self._nGoldBagsExpired
end

function CHoldoutGameRound:CalculateStarRanking()
	local nStarFromBags = 0
	if self:GetGoldBagsExpired() <= 3 then
		nStarFromBags = 3
	end
	if self:GetGoldBagsExpired() > 3 then
		nStarFromBags = 2
	end
	if self:GetGoldBagsExpired() >= 8 then
		nStarFromBags = 1
	end

	local nStarFromDeaths = 0
	self._nTotalDeaths = 0
	for nPlayerID = 0, DOTA_DEFAULT_MAX_TEAM-1 do
		local playerStats = self:GetPlayerStats(nPlayerID)
		if playerStats then
			self._nTotalDeaths = self:GetTotalDeaths() + playerStats.nDeathsThisRound
		end
	end

	print( "Total deaths " .. self:GetTotalDeaths() )

	if self:GetTotalDeaths() <= 1 then
		nStarFromDeaths = 3
	end
	if self:GetTotalDeaths() > 1 then
		nStarFromDeaths = 2
	end
	if self:GetTotalDeaths() > 3 then
		nStarFromDeaths = 1
	end

	self._nStarRanking = math.min( nStarFromDeaths, nStarFromBags )
end

function CHoldoutGameRound:StatusReport( )
	print( string.format( "Enemies remaining: %d", #self._vEnemiesRemaining ) )
	for _,e in pairs( self._vEnemiesRemaining ) do
		if e:IsNull() then
			print( string.format( "<Unit %s Deleted from C++>", e.unitName ) )
		else
			print( e:GetUnitName() )
		end
	end
	print( string.format( "Spawners: %d", #self._vSpawners ) )
	for _,s in pairs( self._vSpawners ) do
		s:StatusReport()
	end
end