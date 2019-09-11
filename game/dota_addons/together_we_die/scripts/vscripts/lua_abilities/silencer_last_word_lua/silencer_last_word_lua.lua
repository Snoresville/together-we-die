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
silencer_last_word_lua = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "lua_abilities/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_last_word_lua", "lua_abilities/silencer_last_word_lua/modifier_silencer_last_word_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function silencer_last_word_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function silencer_last_word_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "debuff_duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- add debuff
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_silencer_last_word_lua", -- modifier name
			{ duration = duration } -- kv
		)

		-- play effects
		self:PlayEffects( enemy )
	end
end

--------------------------------------------------------------------------------
function silencer_last_word_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_silencer/silencer_last_word_status_cast.vpcf"
	local sound_cast = "Hero_Silencer.LastWord.Cast"

	-- Get Data
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end