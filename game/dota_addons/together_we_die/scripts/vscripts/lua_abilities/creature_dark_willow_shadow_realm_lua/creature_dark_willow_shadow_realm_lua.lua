creature_dark_willow_shadow_realm_lua = class({})
LinkLuaModifier( "modifier_creature_dark_willow_shadow_realm_lua", "lua_abilities/creature_dark_willow_shadow_realm_lua/modifier_creature_dark_willow_shadow_realm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_dark_willow_shadow_realm_lua_buff", "lua_abilities/creature_dark_willow_shadow_realm_lua/modifier_creature_dark_willow_shadow_realm_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_dark_willow_shadow_realm_lua:GetIntrinsicModifierName()
	return "modifier_creature_dark_willow_shadow_realm_lua"
end
