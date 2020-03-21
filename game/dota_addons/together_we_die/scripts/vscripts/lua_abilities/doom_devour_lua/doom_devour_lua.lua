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
doom_devour_lua = class({})
doom_devour_lua_slot1 = class({})
doom_devour_lua_slot2 = class({})

LinkLuaModifier( "modifier_doom_devour_lua", "lua_abilities/doom_devour_lua/modifier_doom_devour_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function doom_devour_lua:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- AOE Radius
function doom_devour_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function doom_devour_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "devour_time" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- Find Units in Radius
	local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_CREEP,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
	)

	for _,devourTarget in pairs(targets) do
		-- Play effects and no draw
		self:PlayEffects( devourTarget )
		devourTarget:SetOrigin( devourTarget:GetOrigin() + Vector( 0, 0, -200 ) )

		-- kill target
		devourTarget:Kill( self, caster )

		-- add modifier
		caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_doom_devour_lua", -- modifier name
				{ duration = duration } -- kv
		)
	end
end

--------------------------------------------------------------------------------
function doom_devour_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	local sound_cast = "Hero_DoomBringer.Devour"
	local sound_target = "Hero_DoomBringer.DevourCast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end
