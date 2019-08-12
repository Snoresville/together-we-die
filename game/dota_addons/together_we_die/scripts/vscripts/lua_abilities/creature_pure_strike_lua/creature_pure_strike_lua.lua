creature_pure_strike_lua = class({})
LinkLuaModifier( "modifier_creature_pure_strike_lua", "lua_abilities/creature_pure_strike_lua/modifier_creature_pure_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_pure_strike_lua:GetIntrinsicModifierName()
	return "modifier_creature_pure_strike_lua"
end
