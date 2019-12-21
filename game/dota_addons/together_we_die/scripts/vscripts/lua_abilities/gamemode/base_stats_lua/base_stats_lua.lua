base_stats_lua = class({})
LinkLuaModifier( "modifier_base_stats_lua", "lua_abilities/gamemode/base_stats_lua/modifier_base_stats_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_strength_lua", "lua_abilities/gamemode/base_stats_lua/modifier_strength_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_agility_lua", "lua_abilities/gamemode/base_stats_lua/modifier_agility_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_intelligence_lua", "lua_abilities/gamemode/base_stats_lua/modifier_intelligence_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function base_stats_lua:GetIntrinsicModifierName()
	return "modifier_base_stats_lua"
end
