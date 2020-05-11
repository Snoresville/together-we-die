phantom_lancer_spirit_lance_lua = class({})
LinkLuaModifier( "modifier_phantom_lancer_spirit_lance_lua", "lua_abilities/phantom_lancer_spirit_lance_lua/modifier_phantom_lancer_spirit_lance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_tracking_projectile", "lua_abilities/generic/modifier_generic_tracking_projectile", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- AOE Radius
function phantom_lancer_spirit_lance_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function phantom_lancer_spirit_lance_lua:OnSpellStart()
	-- get references
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
	local projectile_speed = self:GetSpecialValueFor("lance_speed")
	local projectile = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf"
	local radius = self:GetSpecialValueFor("radius")
	local max_targets = self:GetSpecialValueFor( "max_targets" )

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local count = 0
	for _,enemy in pairs(enemies) do
		-- Create Tracking Projectile
		local info = {
			Source = caster,
			Target = enemy,
			Ability = self,
			iMoveSpeed = projectile_speed,
			EffectName = projectile,
			bDodgeable = true,
		}
		info = self:PlayProjectile( info )
		ProjectileManager:CreateTrackingProjectile( info )
		-- Increment count
		count = count + 1
		if count >= max_targets then
			break
		end
	end

	self:PlayEffect1()
end

function phantom_lancer_spirit_lance_lua:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
	self:StopProjectile( kv )

	if hTarget==nil or hTarget:IsInvulnerable() then
		return
	end

	if hTarget:TriggerSpellAbsorb( self ) then
		return
	end

	-- get references
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "lance_damage" ) + caster:GetAgility() * self:GetSpecialValueFor( "agi_multiplier" )
	local duration = self:GetSpecialValueFor( "duration" )

	-- Apply damage
	local damage = {
		victim = hTarget,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	ApplyDamage( damage )

	-- Create illusion
	self:CreateIllusionOnTarget( hTarget )

	-- Add slow
	hTarget:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_phantom_lancer_spirit_lance_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play sound effect
	self:PlayEffect2( hTarget )
end

function phantom_lancer_spirit_lance_lua:PlayEffect1()
	-- load resources
	local sound_cast = "Hero_PhantomLancer.SpiritLance.Throw"

	-- play sound
	EmitSoundOn(sound_cast, self:GetCaster())
end

function phantom_lancer_spirit_lance_lua:PlayEffect2( target )
	-- load resources
	local sound_cast = "Hero_PhantomLancer.SpiritLance.Impact"

	-- play sound
	EmitSoundOn(sound_cast, target)
end

function phantom_lancer_spirit_lance_lua:PlayProjectile( info )
	local tempTable = require('util/tempTable')
	local tracker = info.Target:AddNewModifier(
		info.Source, -- player source
		self, -- ability source
		"modifier_generic_tracking_projectile", -- modifier name
		{ duration = 4 } -- kv
	)
	tracker:PlayTrackingProjectile( info )
	
	info.EffectName = nil
	if not info.ExtraData then info.ExtraData = {} end
	info.ExtraData.tracker = tempTable:AddATValue( tracker )

	return info
end

function phantom_lancer_spirit_lance_lua:StopProjectile( kv )
	local tracker = tempTable:RetATValue( kv.tracker )
	if not tracker:IsNull() then tracker:Destroy() end
end

function phantom_lancer_spirit_lance_lua:CreateIllusionOnTarget( target )
	local caster = self:GetCaster()
	local illusion_duration = self:GetSpecialValueFor( "illusion_duration" )
	local illusion_outgoing_damage = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local illusion_incoming_damage = self:GetSpecialValueFor( "illusion_incoming_damage" )

	local modifyIllusion = function ( illusion )
		illusion:SetControllableByPlayer( caster:GetPlayerID(), false )
		illusion:SetPlayerID( caster:GetPlayerID() )

		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, self, "modifier_illusion", { duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage })
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()

		-- Level Up the unit to the casters level
		local casterLevel = caster:GetLevel()
		for i = 2, casterLevel do
			illusion:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the caster
		illusion:SetAbilityPoints(0)

		local maxAbilities = caster:GetAbilityCount() - 1

		for ability_id = 0, maxAbilities do
			local ability = caster:GetAbilityByIndex(ability_id)
			if ability then
				local abilityLevel = ability:GetLevel()
				if abilityLevel ~= 0 then
					local illusionAbility = illusion:GetAbilityByIndex(ability_id)
					if illusionAbility then
						illusionAbility:SetLevel(abilityLevel)
					else
						-- Add ability
						local abilityName = ability:GetAbilityName()
						local newAbility = illusion:AddAbility(abilityName)
						newAbility:SetLevel(abilityLevel)
					end
				end
			end
		end

		-- Recreate the items of the caster
		for itemSlot=0,5 do
			local item = caster:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end

		-- Set health
		illusion:SetHealth(caster:GetHealth())
		illusion:SetMana(caster:GetMana())
	end

	local origin = target:GetAbsOrigin() + RandomVector(100)

	-- Create unit
	CreateUnitByNameAsync(
		caster:GetUnitName(), -- szUnitName
		origin, -- vLocation,
		true, -- bFindClearSpace,
		caster, -- hNPCOwner,
		caster:GetPlayerOwner(), -- hUnitOwner,
		caster:GetTeamNumber(), -- iTeamNumber
		modifyIllusion
	)
end