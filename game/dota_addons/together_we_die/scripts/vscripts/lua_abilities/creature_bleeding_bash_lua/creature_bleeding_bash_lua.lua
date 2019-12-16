creature_bleeding_bash_lua = class({})
LinkLuaModifier( "modifier_creature_bleeding_bash_lua", "lua_abilities/creature_bleeding_bash_lua/modifier_creature_bleeding_bash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_bleeding_bash_lua_stack", "lua_abilities/creature_bleeding_bash_lua/modifier_creature_bleeding_bash_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_bleeding_bash_lua_bleed", "lua_abilities/creature_bleeding_bash_lua/modifier_creature_bleeding_bash_lua_bleed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_bashed_lua", "lua_abilities/generic/modifier_generic_bashed_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_bleeding_bash_lua:GetIntrinsicModifierName()
	return "modifier_creature_bleeding_bash_lua"
end
