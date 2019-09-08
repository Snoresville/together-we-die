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
viper_viper_strike_lua = class({})
LinkLuaModifier( "modifier_viper_viper_strike_lua", "lua_abilities/viper_viper_strike_lua/modifier_viper_viper_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function viper_viper_strike_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function viper_viper_strike_lua:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cast_range_scepter" )
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function viper_viper_strike_lua:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

function viper_viper_strike_lua:GetManaCost( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "mana_cost_scepter" )
	end

	return self.BaseClass.GetManaCost( self, level )
end

--------------------------------------------------------------------------------
-- Ability Start
function viper_viper_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	-- local projectile_name = "particles/units/heroes/hero_viper/viper_viper_strike.vpcf"
	local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- Play Effects
	local effect = self:PlayEffects( target )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional

		ExtraData = {
			effect = effect,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

end
--------------------------------------------------------------------------------
-- Projectile
function viper_viper_strike_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- stop effects
	self:StopEffects( ExtraData.effect )

	if not target then return end

	-- references
	local duration = self:GetSpecialValueFor( "duration" )


	local enemies = FindUnitsInRadius( 
		self:GetCaster():GetTeamNumber(), 
		target:GetOrigin(), 
		target, 
		self:GetSpecialValueFor( "radius" ), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 
		0, 
		false 
	)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsInvulnerable() ) then
				-- cancel if linken
				if not enemy:TriggerSpellAbsorb( self ) then 
					enemy:AddNewModifier(
						self:GetCaster(), -- player source
						self, -- ability source
						"modifier_viper_viper_strike_lua", -- modifier name
						{ duration = duration } -- kv
					)

					-- play effects
					local sound_cast = "hero_viper.viperStrikeImpact"
					EmitSoundOn( sound_cast, enemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
function viper_viper_strike_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_viper/viper_viper_strike_beam.vpcf"
	local sound_cast = "hero_viper.viperStrike"

	-- Get Data
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 6, Vector( projectile_speed, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- "attach_barb<1/2/3/4>" is unique to viper model, so use something else
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack3",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )

	-- return the particle index
	return effect_cast
end

function viper_viper_strike_lua:StopEffects( effect_cast )
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end