creature_slark_shadow_dance_lua = class({})
LinkLuaModifier("modifier_creature_slark_shadow_dance_lua", "lua_abilities/creature_slark_shadow_dance_lua/modifier_creature_slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_slark_shadow_dance_lua_invis", "lua_abilities/creature_slark_shadow_dance_lua/modifier_creature_slark_shadow_dance_lua_invis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_slark_shadow_dance_lua_thinker", "lua_abilities/creature_slark_shadow_dance_lua/modifier_creature_slark_shadow_dance_lua_thinker", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_slark_shadow_dance_lua:GetIntrinsicModifierName()
    return "modifier_creature_slark_shadow_dance_lua"
end