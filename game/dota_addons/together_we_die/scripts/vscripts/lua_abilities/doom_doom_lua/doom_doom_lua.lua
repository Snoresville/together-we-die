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
doom_doom_lua = class({})
LinkLuaModifier( "modifier_doom_doom_lua", "lua_abilities/doom_doom_lua/modifier_doom_doom_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function doom_doom_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function doom_doom_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local radius = self:GetSpecialValueFor( "radius" )
	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	if caster:HasScepter() then
		duration = self:GetSpecialValueFor( "duration_scepter" )
	end

	-- Find Units in Radius
	local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
	)

	for _,enemy in pairs(targets) do
		-- cancel if linken
		if not enemy:TriggerSpellAbsorb( self ) then
			-- add modifier
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_doom_doom_lua", -- modifier name
					{ duration = duration } -- kv
			)
		end
	end
end