-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
skywrath_mage_concussive_shot_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_concussive_shot_lua", "lua_abilities/skywrath_mage_concussive_shot_lua/modifier_skywrath_mage_concussive_shot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skywrath_mage_concussive_shot_auto_lua", "lua_abilities/skywrath_mage_concussive_shot_lua/modifier_skywrath_mage_concussive_shot_auto_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function skywrath_mage_concussive_shot_lua:GetIntrinsicModifierName()
	return "modifier_skywrath_mage_concussive_shot_auto_lua"
end

--------------------------------------------------------------------------------
-- Projectile
function skywrath_mage_concussive_shot_lua:OnProjectileHit( target, location )
	if not target then return end

	-- get data
	local radius = self:GetSpecialValueFor( "slow_radius" )
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():GetIntellect() * self:GetSpecialValueFor( "int_multiplier" )
	local duration = self:GetSpecialValueFor( "slow_duration" )
	local creep_mult = self:GetSpecialValueFor( "creep_damage_pct" )
	local vision = self:GetSpecialValueFor( "shot_vision" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find units nearby
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- slow
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_skywrath_mage_concussive_shot_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- vision
	AddFOWViewer(
		self:GetCaster():GetTeamNumber(), --nTeamID
		target:GetOrigin(), --vLocation
		vision, --flRadius
		vision_duration, --flDuration
		false --bObstructedVision
	)

	-- play effects
	local sound_target = "Hero_SkywrathMage.ConcussiveShot.Target"
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
function skywrath_mage_concussive_shot_lua:PlayEffects1( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_cast.vpcf"
	local sound_cast = "Hero_SkywrathMage.ConcussiveShot.Cast"

	-- get data
	local projectile_speed = self:GetSpecialValueFor( "speed" )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( projectile_speed, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function skywrath_mage_concussive_shot_lua:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_failure.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end