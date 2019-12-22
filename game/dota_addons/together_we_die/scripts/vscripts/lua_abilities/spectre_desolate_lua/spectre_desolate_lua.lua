spectre_desolate_lua = class({})
LinkLuaModifier( "modifier_spectre_desolate_lua", "lua_abilities/spectre_desolate_lua/modifier_spectre_desolate_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_desolate_lua_stack", "lua_abilities/spectre_desolate_lua/modifier_spectre_desolate_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_desolate_lua_debuff", "lua_abilities/spectre_desolate_lua/modifier_spectre_desolate_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function spectre_desolate_lua:GetIntrinsicModifierName()
	return "modifier_spectre_desolate_lua"
end
