roshan_sun_strike_lua = class({})
LinkLuaModifier( "modifier_roshan_sun_strike_lua_thinker", "lua_abilities/roshan_sun_strike_lua/modifier_roshan_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_sun_strike_lua", "lua_abilities/roshan_sun_strike_lua/modifier_roshan_sun_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_sun_strike_lua:GetIntrinsicModifierName()
	return "modifier_roshan_sun_strike_lua"
end