abaddon_frostmourne_lua = class({})
LinkLuaModifier( "modifier_abaddon_frostmourne_lua", "lua_abilities/abaddon_frostmourne_lua/modifier_abaddon_frostmourne_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_lua_stack", "lua_abilities/abaddon_frostmourne_lua/modifier_abaddon_frostmourne_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_lua_debuff", "lua_abilities/abaddon_frostmourne_lua/modifier_abaddon_frostmourne_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_lua_buff", "lua_abilities/abaddon_frostmourne_lua/modifier_abaddon_frostmourne_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function abaddon_frostmourne_lua:GetIntrinsicModifierName()
	return "modifier_abaddon_frostmourne_lua"
end
