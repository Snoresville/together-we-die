creature_healing_aura_lua = class({})
LinkLuaModifier("modifier_creature_healing_aura_lua", "lua_abilities/creature_healing_aura_lua/modifier_creature_healing_aura_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_healing_aura_lua_effect", "lua_abilities/creature_healing_aura_lua/modifier_creature_healing_aura_lua_effect", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_healing_aura_lua:GetIntrinsicModifierName()
    return "modifier_creature_healing_aura_lua"
end