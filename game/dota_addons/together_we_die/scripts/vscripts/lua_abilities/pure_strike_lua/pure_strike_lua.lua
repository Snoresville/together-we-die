pure_strike_lua = class({})
LinkLuaModifier( "modifier_pure_strike_lua", "lua_abilities/pure_strike_lua/modifier_pure_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function pure_strike_lua:GetIntrinsicModifierName()
	return "modifier_pure_strike_lua"
end
