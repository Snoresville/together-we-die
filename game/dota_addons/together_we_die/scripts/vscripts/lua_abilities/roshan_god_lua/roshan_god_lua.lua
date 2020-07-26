roshan_god_lua = class({})
LinkLuaModifier( "modifier_roshan_god_lua", "lua_abilities/roshan_god_lua/modifier_roshan_god_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_god_lua:GetIntrinsicModifierName()
	return "modifier_roshan_god_lua"
end