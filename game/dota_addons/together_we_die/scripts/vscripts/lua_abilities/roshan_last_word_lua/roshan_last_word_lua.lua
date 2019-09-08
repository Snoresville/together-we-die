--------------------------------------------------------------------------------
roshan_last_word_lua = class({})
LinkLuaModifier( "modifier_roshan_last_word_lua", "lua_abilities/roshan_last_word_lua/modifier_roshan_last_word_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "lua_abilities/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_last_word_lua:GetIntrinsicModifierName()
	return "modifier_roshan_last_word_lua"
end
