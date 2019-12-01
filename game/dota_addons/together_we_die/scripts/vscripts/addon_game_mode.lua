--[[
Holdout Example

	Underscore prefix such as "_function()" denotes a local function and is used to improve readability
	
	Variable Prefix Examples
		"fl"	Float
		"n"		Int
		"v"		Table
		"b"		Boolean
]]

require( "holdout_game_round" )
require( "holdout_game_spawner" )
require( "libraries/notifications" )


if CHoldoutGameMode == nil then
	CHoldoutGameMode = class({})
	_G.CHoldoutGameMode = CHoldoutGameMode
end

-- Precache resources
function Precache( context )
	--PrecacheResource( "particle", "particles/generic_gameplay/winter_effects_hero.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	
	-- PrecacheResource( "particle_folder", "particles/frostivus_gameplay", context )
	PrecacheItemByNameSync( "item_tombstone", context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheItemByNameSync( "item_slippers_of_halcyon", context )
	PrecacheItemByNameSync( "item_greater_clarity", context )
end

-- Actually make the game mode when we activate
function Activate()
	GameRules.holdOut = CHoldoutGameMode()
	GameRules.holdOut:InitGameMode()
end


function CHoldoutGameMode:InitGameMode()
	self._gameStartChecked = false
	self._difficultyVote = 0
	self._difficultyNumberOfVotes = 0
	self._nRoundNumber = 1
	self._lives = 3
	self._currentRound = nil
	self._flLastThinkGameTime = nil
	self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	if not self._entAncient then
		print( "Ancient entity not found!" )
	end

	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	--GameRules:SetCustomGameSetupTimeout( 0 )

	self:_ReadGameConfiguration()
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetStartingGold( 0 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetUseUniversalShopMode( true )
	--GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetStrategyTime( 10.0 )
	-- GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	-- Configure EXP
	local MAX_HERO_LEVEL = 250
	local EXP_CONST = 20
	local xpTable = {}
	for i = 1, MAX_HERO_LEVEL, 1 do
		xpTable[i] = i * i * EXP_CONST
	end
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( xpTable )

	-- Custom console commands
	Convars:RegisterCommand( "holdout_test_round", function(...) return self:_TestRoundConsoleCommand( ... ) end, "Test a round of holdout.", FCVAR_CHEAT )
	Convars:RegisterCommand( "holdout_spawn_gold", function(...) return self._GoldDropConsoleCommand( ... ) end, "Spawn a gold bag.", FCVAR_CHEAT )
	Convars:RegisterCommand( "holdout_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current holdout game.", FCVAR_CHEAT )

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CHoldoutGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "player_reconnected", Dynamic_Wrap( CHoldoutGameMode, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CHoldoutGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CHoldoutGameMode, "OnGameRulesStateChange" ), self )

	CustomGameEventManager:RegisterListener( "select_difficulty",  function(...) return self:_PlayerDifficultySelect( ... ) end)

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
end


-- Read and assign configurable keyvalues if applicable
function CHoldoutGameMode:_ReadGameConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self._bAlwaysShowPlayerGold = kv.AlwaysShowPlayerGold or false
	self._bRestoreHPAfterRound = kv.RestoreHPAfterRound or false
	self._bRestoreMPAfterRound = kv.RestoreMPAfterRound or false
	self._bRewardForTowersStanding = kv.RewardForTowersStanding or false
	self._bUseReactiveDifficulty = kv.UseReactiveDifficulty or false

	self._nTowerRewardAmount = tonumber( kv.TowerRewardAmount or 0 )
	self._nTowerScalingRewardPerRound = tonumber( kv.TowerScalingRewardPerRound or 0 )

	self._flPrepTimeBetweenRounds = tonumber( kv.PrepTimeBetweenRounds or 0 )
	self._flItemExpireTime = tonumber( kv.ItemExpireTime or 10.0 )

	self:_ReadRandomSpawnsConfiguration( kv["RandomSpawns"] )
	self:_ReadLootItemDropsConfiguration( kv["ItemDrops"] )
	self:_ReadRoundConfigurations( kv )
end


-- Verify spawners if random is set
function CHoldoutGameMode:ChooseRandomSpawnInfo()
	if #self._vRandomSpawnsList == 0 then
		error( "Attempt to choose a random spawn, but no random spawns are specified in the data." )
		return nil
	end
	return self._vRandomSpawnsList[ RandomInt( 1, #self._vRandomSpawnsList ) ]
end


-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CHoldoutGameMode:_ReadRandomSpawnsConfiguration( kvSpawns )
	self._vRandomSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end
	for _,sp in pairs( kvSpawns ) do			-- Note "_" used as a shortcut to create a temporary throwaway variable
		table.insert( self._vRandomSpawnsList, {
			szSpawnerName = sp.SpawnerName or "",
			szFirstWaypoint = sp.Waypoint or ""
		} )
	end
end


-- If random drops are defined read in that data
function CHoldoutGameMode:_ReadLootItemDropsConfiguration( kvLootDrops )
	self._vLootItemDropsList = {}
	if type( kvLootDrops ) ~= "table" then
		return
	end
	for _,lootItem in pairs( kvLootDrops ) do
		table.insert( self._vLootItemDropsList, {
			szItemName = lootItem.Item or "",
			nChance = tonumber( lootItem.Chance or 0 )
		})
	end
end


-- Set number of rounds without requiring index in text file
function CHoldoutGameMode:_ReadRoundConfigurations( kv )
	self._vRounds = {}
	while true do
		local szRoundName = string.format("Round%d", #self._vRounds + 1 )
		local kvRoundData = kv[ szRoundName ]
		if kvRoundData == nil then
			return
		end
		local roundObj = CHoldoutGameRound()
		roundObj:ReadConfiguration( kvRoundData, self, #self._vRounds + 1 )
		table.insert( self._vRounds, roundObj )
	end
end


-- When game state changes set state in script
function CHoldoutGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_BeginGameSetup()
		self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	end
end


-- Evaluate the state of the game
function CHoldoutGameMode:OnThink()
	local currentGameState = GameRules:State_Get()
	if currentGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()
		self:_ThinkLootExpiry()

		if self._flPrepTimeEnd ~= nil then
			self:_ThinkPrepTime()
		elseif self._currentRound ~= nil then
			if not self._gameStartChecked then
				self:_GameStartCheck()
			end

			self._currentRound:Think()
			if self._currentRound:IsFinished() then
				self._currentRound:End()
				self._currentRound = nil
				-- Heal all players
				self:_RefreshPlayers()
				-- Respawn all buildings
				self:_RespawnBuildings()

				self._nRoundNumber = self._nRoundNumber + 1
				if self._nRoundNumber > #self._vRounds then
					self._nRoundNumber = 1
					GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
				else
					-- Report round status
					self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
				end
			end
		end
	elseif currentGameState >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return 1
end

function CHoldoutGameMode:OnGoldInterval()
	local goldPerTick = 1
	local currentGameState = GameRules:State_Get()

	if currentGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not GameRules:IsGamePaused() then
			-- no gold while paused
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					-- unreliable gold
					PlayerResource:ModifyGold( nPlayerID, goldPerTick, false, DOTA_ModifyGold_GameTick )
				end
			end
		end
	elseif currentGameState >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end

	return 1
end

function CHoldoutGameMode:_GameStartCheck()
	self:_CalculateAndApplyDifficulty()

	self._gameStartChecked = true
end

function CHoldoutGameMode:_BeginGameSetup()
	-- Start difficulty vote
	CustomGameEventManager:Send_ServerToAllClients( "show_difficulty_vote", {} )

	-- Create courier for every player
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local player = PlayerResource:GetPlayer( nPlayerID )
			local player_hero = player:GetAssignedHero()
			local courier = CreateUnitByName(
				"npc_dota_courier", -- szUnitName
				player_hero:GetOrigin(), -- vLocation,
				true, -- bFindClearSpace,
				player_hero, -- hNPCOwner,
				player, -- hUnitOwner,
				player:GetTeamNumber() -- iTeamNumber
			)
			courier:SetControllableByPlayer( nPlayerID, false ) -- (playerID, bSkipAdjustingPosition)
			courier:SetOwner( player )

			-- Set level to 11 if it is enemy team
			if player_hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				for i = 0, 9 do
					player_hero:HeroLevelUp(false)
				end
			end
		end
	end

	-- Check for any alliance types
	self:_CheckForAlliance()
end

function CHoldoutGameMode:_CalculateAndApplyDifficulty()
	local difficultyNumberOfVotes = self:_GetDifficultyNumberOfVotes()
	local difficultyScore = 1
	local startingGold = 0
	local difficultyAbility = nil
	if difficultyNumberOfVotes ~= 0 then
		difficultyScore = math.floor(self:_GetDifficultyVote() / difficultyNumberOfVotes)
	end

	local playerCount = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )

	local difficultyTitle = "DOTA_HUD_Difficulty_Easy"
	if difficultyScore == 1 then
		difficultyAbility = self._entAncient:AddAbility( "easy_difficulty_lua" )
		self._nTowerRewardAmount = self._nTowerRewardAmount * 1.35
		self._nTowerScalingRewardPerRound = self._nTowerScalingRewardPerRound * 1.35
		startingGold = math.floor(10000 / playerCount)
		GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	elseif difficultyScore == 2 then
		difficultyAbility = self._entAncient:AddAbility( "normal_difficulty_lua" )
		difficultyTitle = "DOTA_HUD_Difficulty_Normal"
		startingGold = math.floor(5000 / playerCount)
	elseif difficultyScore == 3 then
		difficultyAbility = self._entAncient:AddAbility( "hard_difficulty_lua" )
		difficultyTitle = "DOTA_HUD_Difficulty_Hard"
		self._lives = 2
		self._nTowerRewardAmount = math.floor( self._nTowerRewardAmount * 0.75 )
		self._nTowerScalingRewardPerRound = math.floor( self._nTowerScalingRewardPerRound * 0.75 )
		startingGold = math.floor(2000 / playerCount)
	elseif difficultyScore == 4 then
		difficultyAbility = self._entAncient:AddAbility( "impossible_difficulty_lua" )
		difficultyTitle = "DOTA_HUD_Difficulty_Impossible"
		self._lives = 1
		self._nTowerRewardAmount = math.floor( self._nTowerRewardAmount * 0.5 )
		self._nTowerScalingRewardPerRound = math.floor( self._nTowerScalingRewardPerRound * 0.5 )
		startingGold = math.floor(500 / playerCount)
	end
	-- Set to level 1
	difficultyAbility:SetLevel( 1 )

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS then
				-- bad guys get more gold
				PlayerResource:ModifyGold( nPlayerID, startingGold * playerCount, true, DOTA_ModifyGold_Unspecified )
				local player = PlayerResource:GetPlayer( nPlayerID )
				local player_hero = player:GetAssignedHero()
				local badGuyAbility = player_hero:AddAbility( "bad_guy_lua" )
				badGuyAbility:SetLevel( 1 )
			else
				PlayerResource:ModifyGold( nPlayerID, startingGold, true, DOTA_ModifyGold_Unspecified )
			end
		end
	end

	self:_SetExpAndRespawn( difficultyScore )

	local event_data = {
		difficulty_title = difficultyTitle,
	}

	CustomGameEventManager:Send_ServerToAllClients( "show_difficulty_vote_outcome", event_data )
end

function CHoldoutGameMode:_SetExpAndRespawn( difficultyScore )
	difficultyScore = difficultyScore or 1
	local goldTickTime = 0.5 * difficultyScore
	local respawnTime = 9.5 * difficultyScore

	GameRules:GetGameModeEntity():SetThink( "OnGoldInterval", self, goldTickTime )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( respawnTime )
end

function CHoldoutGameMode:_CheckForAlliance()
	local MIN_COMBO_FOR_ALLIANCE = 3
	local allianceCount = {
		["female"] = 0,
		["warrior"] = 0,
		["nature"] = 0,
	}
	local foundAllianceHeroes = {
		["female"] = {},
		["warrior"] = {},
		["nature"] = {},
	}
	local femaleAllianceHeroes = {
		["npc_dota_hero_phanthom_assassin"] = true,
		["npc_dota_hero_windrunner"] = true,
		["npc_dota_hero_crystal_maiden"] = true,
		["npc_dota_hero_drow_ranger"] = true,
		["npc_dota_hero_legion_commander"] = true,
		["npc_dota_hero_lina"] = true,
		["npc_dota_hero_dark_willow"] = true,
		["npc_dota_hero_luna"] = true,
		["npc_dota_hero_medusa"] = true,
		["npc_dota_hero_queenofpain"] = true,
	}

	local warriorAllianceHeroes = {
		["npc_dota_hero_legion_commander"] = true,
		["npc_dota_hero_mars"] = true,
		["npc_dota_hero_axe"] = true,
		["npc_dota_hero_sven"] = true,
		["npc_dota_hero_juggernaut"] = true,
		["npc_dota_hero_centaur"] = true,
		["npc_dota_hero_skeleton_king"] = true,
		["npc_dota_hero_phantom_lancer"] = true,
		["npc_dota_hero_sand_king"] = true,
		["npc_dota_hero_huskar"] = true,
		["npc_dota_hero_bristleback"] = true,
	}

	local natureAllianceHeroes = {
		["npc_dota_hero_windrunner"] = true,
		["npc_dota_hero_furion"] = true,
		["npc_dota_hero_enchantress"] = true,
		["npc_dota_hero_ursa"] = true,
		["npc_dota_hero_leshrac"] = true,
		["npc_dota_hero_dark_willow"] = true,
	}

	local scaleAllianceHeroes = {
		["npc_dota_hero_slardar"] = true,
		["npc_dota_hero_medusa"] = true,
		["npc_dota_hero_slark"] = true,
	}

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				-- hero not selected
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				local heroName = hero:GetUnitName()

				if femaleAllianceHeroes[heroName] then
					foundAllianceHeroes["female"][nPlayerID] = hero:entindex()
					allianceCount["female"] = allianceCount["female"] + 1
				end
		
				if warriorAllianceHeroes[heroName] then
					foundAllianceHeroes["warrior"][nPlayerID] = hero:entindex()
					allianceCount["warrior"] = allianceCount["warrior"] + 1
				end

				if natureAllianceHeroes[heroName] then
					foundAllianceHeroes["nature"][nPlayerID] = hero:entindex()
					allianceCount["nature"] = allianceCount["nature"] + 1
				end
			end
		end
	end

	if allianceCount["female"] >= MIN_COMBO_FOR_ALLIANCE then
		for _,hero in pairs( foundAllianceHeroes["female"] ) do
			local heroEntity = EntIndexToHScript(hero)
			local femaleAllianceAbility = heroEntity:AddAbility("alliance_female")
			femaleAllianceAbility:SetLevel( 1 )
		end
	end

	if allianceCount["warrior"] >= MIN_COMBO_FOR_ALLIANCE then
		for _,hero in pairs( foundAllianceHeroes["warrior"] ) do
			local heroEntity = EntIndexToHScript(hero)
			local warriorAllianceAbility = heroEntity:AddAbility("alliance_warrior")
			warriorAllianceAbility:SetLevel( 1 )
		end
	end

	if allianceCount["nature"] >= MIN_COMBO_FOR_ALLIANCE then
		for _,hero in pairs( foundAllianceHeroes["nature"] ) do
			local heroEntity = EntIndexToHScript(hero)
			local natureAllianceAbility = heroEntity:AddAbility("alliance_nature")
			natureAllianceAbility:SetLevel( 1 )
		end
	end
end

function CHoldoutGameMode:_RefreshPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					hero:RespawnUnit()
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end


function CHoldoutGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	if not self._entAncient or self._entAncient:GetHealth() <= 5 then
		self._lives = self._lives - 1
		if self._lives <= 0 then
			self._entAncient:ForceKill( true )
			GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			return
		else
			-- Restart round and respawn buildings
			Notifications:TopToAll({text="Lives Left: " .. self._lives, duration=5.0})
			if self._currentRound ~= nil then
				self._currentRound:End()
				self._currentRound = nil
			end
		
			for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
				local containedItem = item:GetContainedItem()
				if containedItem then
					UTIL_RemoveImmediate( containedItem )
				end
				UTIL_RemoveImmediate( item )
			end
		
			self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
			self:_RefreshPlayers()
			self:_RespawnBuildings( true )
		end
	end
end


function CHoldoutGameMode:_ThinkPrepTime()
	if GameRules:GetGameTime() >= self._flPrepTimeEnd then
		self._flPrepTimeEnd = nil
		if self._entPrepTimeQuest then
			UTIL_RemoveImmediate( self._entPrepTimeQuest )
			self._entPrepTimeQuest = nil
		end

		if self._nRoundNumber > #self._vRounds then
			GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			return false
		end
		self._currentRound = self._vRounds[ self._nRoundNumber ]
		self._currentRound:Begin()
		self:_NotifyClientOfRoundStart()
		return
	end

	if not self._entPrepTimeQuest then
		self._entPrepTimeQuest = SpawnEntityFromTableSynchronous( "quest", { name = "PrepTime", title = "#DOTA_Quest_Holdout_PrepTime" } )
		self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self._nRoundNumber )
		self._entPrepTimeQuest:SetTextReplaceString( self:GetDifficultyString() )

		self._vRounds[ self._nRoundNumber ]:Precache()
	end
	self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self._flPrepTimeEnd - GameRules:GetGameTime() )
end


function CHoldoutGameMode:_ThinkLootExpiry()
	if self._flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetGameTime() - self._flItemExpireTime

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem:GetAbilityName() == "item_bag_of_gold" or item.Holdout_IsLootDrop then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
	end
end


function CHoldoutGameMode:_ProcessItemForLootExpiry( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local containedItem = item:GetContainedItem()
	if containedItem and containedItem:GetAbilityName() == "item_bag_of_gold" then
		if self._currentRound and self._currentRound.OnGoldBagExpired then
			self._currentRound:OnGoldBagExpired()
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end


function CHoldoutGameMode:GetDifficultyString()
	local nDifficulty = GameRules:GetCustomGameDifficulty()
	if nDifficulty > 4 then
		return string.format( "(+%d)", nDifficulty )
	elseif nDifficulty > 0 then
		return string.rep( "+", nDifficulty )
	else
		return ""
	end
end

function CHoldoutGameMode:ForceAssignHeroes()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				print( "  Hero selection time is over: forcing nPlayerID " .. nPlayerID .. " to random a hero." )
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end


function CHoldoutGameMode:_SpawnHeroClientEffects( hero, nPlayerID )
	-- Spawn these effects on the client, since we don't need them to stay in sync or anything
	-- ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/winter_effects_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )	-- Attaches the breath effects to players for winter maps
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/frostivus_gameplay/frostivus_hero_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )
end


function CHoldoutGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsCreature() then
		spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
		spawnedUnit:SetManaGain( 0 )
		spawnedUnit:SetHPRegenGain( 0 )
		spawnedUnit:SetManaRegenGain( 0 )
		if spawnedUnit:IsRangedAttacker() then
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.1 ) -- LEVEL SCALING VALUE FOR DPS
		else
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.2 ) -- LEVEL SCALING VALUE FOR DPS
		end
		spawnedUnit:SetArmorGain( 0 )
		spawnedUnit:SetMagicResistanceGain( 0 )
		spawnedUnit:SetDisableResistanceGain( 0 )
		spawnedUnit:SetAttackTimeGain( 0 )
		spawnedUnit:SetMoveSpeedGain( 0 )
		spawnedUnit:SetBountyGain( 0 )
		spawnedUnit:SetXPGain( 0 )
		spawnedUnit:CreatureLevelUp( GameRules:GetCustomGameDifficulty() )
	end

	-- Attach client side hero effects on spawning players
	if spawnedUnit:IsRealHero() then
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
				self:_SpawnHeroClientEffects( spawnedUnit, nPlayerID )
			end
		end
	end
end


-- Attach client-side hero effects for a reconnecting player
function CHoldoutGameMode:OnPlayerReconnected( event )
	local nReconnectedPlayerID = event.PlayerID
	for _, hero in pairs( Entities:FindAllByClassname( "npc_dota_hero" ) ) do
		if hero:IsRealHero() then
			self:_SpawnHeroClientEffects( hero, nReconnectedPlayerID )
		end
	end
end


function CHoldoutGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit and killedUnit:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedUnit )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	
	end
end


function CHoldoutGameMode:CheckForLootItemDrop( killedUnit )
	for _,itemDropInfo in pairs( self._vLootItemDropsList ) do
		if RollPercentage( itemDropInfo.nChance ) then
			local newItem = CreateItem( itemDropInfo.szItemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( true )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
		end
	end
end


function CHoldoutGameMode:ComputeTowerBonusGold( nTowersTotal, nTowersStanding )
	local nRewardPerTower = self._nTowerRewardAmount + self._nTowerScalingRewardPerRound * (self._nRoundNumber - 1)
	return nRewardPerTower * nTowersStanding
end

--------------------------------------------------------------------------------

function CHoldoutGameMode:_RespawnBuildings(lostLife)
	lostLife = lostLife or false
	-- Respawn all the towers.
	self:_PhaseAllUnits( true )

	if self._entAncient and not self._entAncient:IsNull() then
		self._entAncient:SetHealth( self._entAncient:GetMaxHealth() )
		self._entAncient:AddNewModifier( self._entAncient, nil, "modifier_invulnerable", {} )
		self._entAncient:SetInvulnCount( 2 )
	end

	local buildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
	for _,building in ipairs( buildings ) do
		if building:IsTower() then
			local sModelName = "models/props_structures/tower_good.vmdl"
			local TOWER_ARMOR = 5
			building:SetOriginalModel( sModelName )
			building:SetModel( sModelName )
			local vOrigin = building:GetOrigin()
			if building:IsAlive() and not lostLife then
				-- Increase health of tower if alive AND round was not lost
				local baseHealth = building:GetMaxHealth()
				local newHealth = baseHealth + (400 * self._nRoundNumber)
				building:SetBaseMaxHealth(newHealth)
				building:Heal( newHealth, building )
			else
				building:RespawnUnit()
				building:SetPhysicalArmorBaseValue( TOWER_ARMOR ) -- using this hack because RespawnUnit wipes our armor and I don't want to fix RespawnUnit right now
			end
			building:SetOrigin( vOrigin )

			if not building:HasAbility( "tower_fortification" ) then building:AddAbility( "tower_fortification" ) end
			local fortificationAbility = building:FindAbilityByName( "tower_fortification" )
			if fortificationAbility then
				fortificationAbility:SetLevel( math.floor(self._nRoundNumber / 2) )
			end

			building:RemoveModifierByName( "modifier_invulnerable" )
		end
	end
	self:_PhaseAllUnits( false )
end

--------------------------------------------------------------------------------

function CHoldoutGameMode:_PhaseAllUnits( bPhase )
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, 0, FIND_ANY_ORDER, false )
	for _,unit in ipairs(units) do
		if bPhase then
			unit:AddNewModifier( units[i], nil, "modifier_phased", {} )
		else
			unit:RemoveModifierByName( "modifier_phased" )
		end
	end
end

-- Custom game specific console command "holdout_test_round"
function CHoldoutGameMode:_TestRoundConsoleCommand( cmdName, roundNumber, delay )
	local nRoundToTest = tonumber( roundNumber )
	print (string.format( "Testing round %d", nRoundToTest ) )
	if nRoundToTest <= 0 or nRoundToTest > #self._vRounds then
		Msg( string.format( "Cannot test invalid round %d", nRoundToTest ) )
		return
	end

	if self._currentRound ~= nil then
		self._currentRound:End()
		self._currentRound = nil
	end

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem then
			UTIL_RemoveImmediate( containedItem )
		end
		UTIL_RemoveImmediate( item )
	end

	self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	self._nRoundNumber = nRoundToTest
	self:_RespawnBuildings()
	if delay ~= nil then
		self._flPrepTimeEnd = GameRules:GetGameTime() + tonumber( delay )
	end
end

function CHoldoutGameMode:_GoldDropConsoleCommand( cmdName, goldToDrop )
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	if goldToDrop == nil then goldToDrop = 100 end
	newItem:SetCurrentCharges( goldToDrop )
	local spawnPoint = Vector( 0, 0, 0 )
	local heroEnt = PlayerResource:GetSelectedHeroEntity( 0 )
	if heroEnt ~= nil then
		spawnPoint = heroEnt:GetAbsOrigin()
	end
	local drop = CreateItemOnPositionSync( spawnPoint, newItem )
	newItem:LaunchLoot( true, 300, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 350 ) ) )
end

function CHoldoutGameMode:_NotifyClientOfRoundStart()
	local netTable = {}
	if self._currentRound then
		netTable["round_number"] = self._currentRound:GetRoundNumber()
		netTable["round_name"] = self._currentRound:GetRoundTitle()
		netTable["round_description"] = self._currentRound:GetRoundDescription()
	end
	CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
	self:_SendRoundDataToClient()
end

function CHoldoutGameMode:_SendRoundDataToClient()
	local netTable = {}

	netTable["round_number"] = self._nRoundNumber
	netTable["prep_time_left"] = 0
	if self._flPrepTimeEnd then
		netTable["prep_time_left"] = self._flPrepTimeEnd - GameRules:GetGameTime()
	end
	
	netTable["enemies_killed"] = 0
	netTable["enemies_total"] = 1

	if self._currentRound then
		netTable["enemies_killed"] = self._currentRound:GetTotalUnitsKilled()
		netTable["enemies_total"] = self._currentRound:GetTotalUnits()

		self:_SendScoresToClient( false )
	end

	CustomNetTables:SetTableValue( "round_data", string.format( "%d", 0 ), netTable )
end


function CHoldoutGameMode:_SendScoresToClient( bRoundOver )
	local netTable = {}
	netTable["GoldBagsCollected"] = 0
	for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		local nPlayerID = i
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local playerStatsForRound = self._currentRound:GetPlayerStats( nPlayerID )
			local szPlayerID = string.format( "%d", nPlayerID )

			netTable[ szPlayerID .. "Kills" ] = playerStatsForRound.nCreepsKilled
			netTable[ szPlayerID .. "Deaths" ] = playerStatsForRound.nDeathsThisRound
			netTable[ szPlayerID .. "Bags" ] = playerStatsForRound.nGoldBagsCollected
			netTable[ szPlayerID .. "Saves" ] = playerStatsForRound.nPlayersResurrected

			netTable["GoldBagsCollected"] = netTable["GoldBagsCollected"] + playerStatsForRound.nGoldBagsCollected
		end
	end

	netTable["TowersRemaining"] = self._currentRound:GetTowersRemaining()
	netTable["GoldBagsExpired"] = self._currentRound:GetGoldBagsExpired()
	netTable["RoundOver"] = bRoundOver

	if bRoundOver == true then
		netTable["TowersReward"] = self._currentRound:GetTowersStandingGoldReward()
		netTable["StarLevel"] = self._currentRound:GetStarRanking()
		netTable["TotalDeaths"] = self._currentRound:GetTotalDeaths()

		CustomGameEventManager:Send_ServerToAllClients( "round_over", {} )

		--local award = self._currentRound:GetRoundAward()
		--if award ~= nil then
			--CustomGameEventManager:Send_ServerToAllClients( "display_award", award )
		--end
	end

	CustomNetTables:SetTableValue( "holdout_scores", string.format( "%d", 0 ), netTable )
end

function CHoldoutGameMode:_GetDifficultyVote()
	return self._difficultyVote
end

function CHoldoutGameMode:_GetDifficultyNumberOfVotes()
	return self._difficultyNumberOfVotes
end

function CHoldoutGameMode:_PlayerDifficultySelect( eventSourceIndex, args )
	local difficultyLevel = tonumber(args['difficulty'])
	self._difficultyVote = self:_GetDifficultyVote() + difficultyLevel
	self._difficultyNumberOfVotes = self:_GetDifficultyNumberOfVotes() + 1
end

function CHoldoutGameMode:_StatusReportConsoleCommand( cmdName )
	print( "*** Holdout Status Report ***" )
	print( string.format( "Current Round: %d", self._nRoundNumber ) )
	if self._currentRound then
		self._currentRound:StatusReport()
	end
	print( "*** Holdout Status Report End *** ")
end
