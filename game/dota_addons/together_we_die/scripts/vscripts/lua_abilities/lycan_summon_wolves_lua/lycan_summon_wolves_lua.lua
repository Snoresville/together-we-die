lycan_summon_wolves_lua = class({})
LinkLuaModifier( "modifier_lycan_summon_wolves_lua", "lua_abilities/lycan_summon_wolves_lua/modifier_lycan_summon_wolves_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_summon_wolves_lua_visuals", "lua_abilities/lycan_summon_wolves_lua/modifier_lycan_summon_wolves_lua_visuals", LUA_MODIFIER_MOTION_NONE )

-------------------------

function lycan_summon_wolves_lua:GetIntrinsicModifierName()
    return "modifier_lycan_summon_wolves_lua_visuals"
end

function lycan_summon_wolves_lua:GetMasteryStack()
	if not IsServer() then return end
	
	if self.mastery == nil then
        self.mastery = 0
    end
	
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByNameAndCaster( "modifier_lycan_summon_wolves_lua_visuals", caster )
	modifier:SetStackCount(self.mastery)
	
    return self.mastery
end

function lycan_summon_wolves_lua:IncreaseMastery()
    self.mastery = self:GetMasteryStack() + 1
end

function lycan_summon_wolves_lua:WolfSkills(hWolf)
	-- Upgrades the passive wolf skill based on Mastery Stacks
	local masteryAbility = hWolf:AddAbility("lycan_wolf_mastery_lua")
	
	local milestone = math.min(math.floor(self:GetMasteryStack()/500), 10)
	masteryAbility:SetLevel(milestone)
end

function lycan_summon_wolves_lua:KillWolves()
	local targets = self.wolves or {}
	for _,unit in pairs(targets) do	
		if unit and IsValidEntity(unit) then
			unit:ForceKill(false)
		end
	end
end

function lycan_summon_wolves_lua:OnSpellStart()
	
	-- Gets the number of wolves to summon
	local wolfcountBase = self:GetSpecialValueFor( "wolf_count" )
	local wolfcountFromStrength = math.floor(self:GetCaster():GetStrength()/self:GetSpecialValueFor( "extra_wolves_from_strength" ))
	local wolfcountTotal = wolfcountBase + wolfcountFromStrength
	
	-- Determining the stats of a wolf
	-- From Stats
	local wolfHealthBuff = self:GetCaster():GetStrength() * self:GetSpecialValueFor( "wolf_hp_per_strength" )
	local wolfArmorBuff = self:GetCaster():GetAgility() * self:GetSpecialValueFor( "wolf_armor_per_agility" )
	local wolfDurationBuff = self:GetCaster():GetIntellect() * self:GetSpecialValueFor( "wolf_duration_per_intelligence" ) + self:GetSpecialValueFor( "wolf_duration" )
	
	-- From Stacks
	local wolfDamageBuff = self:GetMasteryStack() * self:GetSpecialValueFor( "wolf_damage_per_stack" )
	
	-- Positioning the wolf spawn
	local caster = self:GetCaster()
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local frontPosition = origin + fv * 200
	
	-- Creating the Wolves
	self:KillWolves()
	self.wolves = { }
	
	for i = 1,wolfcountTotal do
		local abilityLevel = self:GetLevel()
		local rotatePos = RotatePosition(origin, QAngle(0, i/wolfcountTotal * 360, 0), frontPosition)
		local hWolf = CreateUnitByName( "npc_dota_lycan_wolf1", rotatePos, true, self:GetCaster(), self:GetCaster():GetPlayerOwner(), self:GetCaster():GetTeamNumber() )
		if hWolf ~= nil then
			hWolf:SetControllableByPlayer( self:GetCaster():GetPlayerID(), false )
			hWolf:SetOwner( self:GetCaster() )
			
			-- Setting the Stats
			local wolf_max_dmg = self:GetSpecialValueFor( "wolf_damage" ) + wolfDamageBuff
			local wolf_min_dmg = self:GetSpecialValueFor( "wolf_damage" ) + wolfDamageBuff
			local wolf_hp = self:GetSpecialValueFor( "wolf_hp" ) + wolfHealthBuff
			hWolf:SetBaseDamageMax( wolf_max_dmg )
			hWolf:SetBaseDamageMin( wolf_min_dmg )
			hWolf:SetBaseMaxHealth( wolf_hp )
			hWolf:SetPhysicalArmorBaseValue(wolfArmorBuff)
			hWolf:SetBaseAttackTime(self:GetSpecialValueFor( "wolf_bat" ))
			
			-- Mastery 'Abilities'
			self:WolfSkills(hWolf)
			
			-- Wolf Metadata
			local kv = {
				duration = wolfDurationBuff
			}
			
			hWolf:SetAcquisitionRange(99999)
			hWolf:SetForwardVector(fv)
			hWolf:AddNewModifier( self:GetCaster(), self, "modifier_lycan_summon_wolves_lua", kv )
			
			table.insert(self.wolves, hWolf)
			
		end
	end
	
	EmitSoundOnLocationWithCaster( origin, "Hero_Lycan.SummonWolves", self:GetCaster() )
end