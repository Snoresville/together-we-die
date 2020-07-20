roshan_defense_shell_lua = class({})
LinkLuaModifier( "modifier_roshan_defense_shell_lua", "lua_abilities/roshan_defense_shell_lua/modifier_roshan_defense_shell_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_defense_shell_lua:GetIntrinsicModifierName()
	return "modifier_roshan_defense_shell_lua"
end