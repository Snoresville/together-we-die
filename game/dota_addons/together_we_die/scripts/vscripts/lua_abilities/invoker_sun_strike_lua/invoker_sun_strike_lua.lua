invoker_sun_strike_lua = class({})
LinkLuaModifier( "modifier_invoker_sun_strike_lua_thinker", "lua_abilities/invoker_sun_strike_lua/modifier_invoker_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function invoker_sun_strike_lua:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end

	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function invoker_sun_strike_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

-- Commented out for Cataclysm talent when available
--------------------------------------------------------------------------------
-- function invoker_sun_strike_lua:GetCooldown( level )
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetSpecialValueFor( "cooldown_scepter" )
-- 	end

-- 	return self.BaseClass.GetCooldown( self, level )
-- end

--------------------------------------------------------------------------------
-- Ability Cast Filter
-- function invoker_sun_strike_lua:CastFilterResultTarget( hTarget )
-- 	if self:GetCaster() == hTarget then
-- 		return UF_FAIL_CUSTOM
-- 	end

-- 	local nResult = UnitFilter(
-- 		hTarget,
-- 		DOTA_UNIT_TARGET_TEAM_BOTH,
-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
-- 		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
-- 		self:GetCaster():GetTeamNumber()
-- 	)
-- 	if nResult ~= UF_SUCCESS then
-- 		return nResult
-- 	end

-- 	return UF_SUCCESS
-- end

-- function invoker_sun_strike_lua:GetCustomCastErrorTarget( hTarget )
-- 	if self:GetCaster() == hTarget then
-- 		return "#dota_hud_error_cant_cast_on_self"
-- 	end

-- 	return ""
-- end

--------------------------------------------------------------------------------
-- Ability Start
function invoker_sun_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	if self:GetCaster():HasScepter() then
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			self:SunStrikeLoc( caster, enemy:GetOrigin() )
		end
	else
		self:SunStrikeLoc( caster, self:GetCursorPosition() )
	end

end

function invoker_sun_strike_lua:SunStrikeLoc( caster, point )
	-- get values
	local delay = self:GetSpecialValueFor("delay")
	local vision_distance = self:GetSpecialValueFor("vision_distance")
	local vision_duration = self:GetSpecialValueFor("vision_duration")
	-- create modifier thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_invoker_sun_strike_lua_thinker",
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)
	-- create vision
	AddFOWViewer( caster:GetTeamNumber(), point, vision_distance, vision_duration, false )
end