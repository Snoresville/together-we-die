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
	local damage = self:GetSpecialValueFor("lance_damage") + caster:GetAgility() * self:GetSpecialValueFor("agi_multiplier")
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

	-- Add slow
	hTarget:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_phantom_lancer_spirit_lance_lua", -- modifier name
		{ duration = duration } -- kv
	)
end

function phantom_lancer_spirit_lance_lua:PlayEffect1()
	-- load resources
	local sound_cast = "Hero_ChaosKnight.ChaosBolt.Cast"

	-- play sound
	EmitSoundOn(sound_cast, self:GetCaster())
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