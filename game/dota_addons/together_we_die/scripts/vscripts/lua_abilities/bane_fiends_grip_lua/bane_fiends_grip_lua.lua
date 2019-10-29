bane_fiends_grip_lua = class({})
LinkLuaModifier( "modifier_bane_fiends_grip_lua", "lua_abilities/bane_fiends_grip_lua/modifier_bane_fiends_grip_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function bane_fiends_grip_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function bane_fiends_grip_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- load data
	local duration = self:GetSpecialValueFor("fiend_grip_duration")

	for _,enemy in pairs(targets) do
		-- cancel if linken
		if not enemy:TriggerSpellAbsorb( self ) then
			-- add modifier
			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_bane_fiends_grip_lua", -- modifier name
				{ duration = duration } -- kv
			)
		end
	end
end