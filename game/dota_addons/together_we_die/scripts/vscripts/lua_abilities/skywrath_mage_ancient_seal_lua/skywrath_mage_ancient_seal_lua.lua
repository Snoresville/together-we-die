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
skywrath_mage_ancient_seal_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_ancient_seal_lua", "lua_abilities/skywrath_mage_ancient_seal_lua/modifier_skywrath_mage_ancient_seal_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function skywrath_mage_ancient_seal_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
--------------------------------------------------------------------------------

-- Ability Start
function skywrath_mage_ancient_seal_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor( "seal_duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- add debuff
	self:SearchAndDebuff( caster, target, radius, duration )

	-- scepter effect
	if caster:HasScepter() then
		local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
		
		-- find nearby enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- 'enemies' will only have at max 1 hero (others are creeps), which would be 'target'
		local target_2 = enemies[1]		-- could be nil
		if target_2 == target then
			target_2 = enemies[2]	-- could be nil
		end

		if target_2 then
			-- add debuff
			self:SearchAndDebuff( caster, target_2, radius, duration )
		end

	end
end

function skywrath_mage_ancient_seal_lua:SearchAndDebuff( caster, target, radius, duration )
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
			"modifier_skywrath_mage_ancient_seal_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
end