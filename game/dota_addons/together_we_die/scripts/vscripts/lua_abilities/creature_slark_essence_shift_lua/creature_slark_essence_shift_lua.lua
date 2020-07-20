creature_slark_essence_shift_lua = class({})
LinkLuaModifier("modifier_creature_slark_essence_shift_lua", "lua_abilities/creature_slark_essence_shift_lua/modifier_creature_slark_essence_shift_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_slark_essence_shift_lua_debuff", "lua_abilities/creature_slark_essence_shift_lua/modifier_creature_slark_essence_shift_lua_debuff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_slark_essence_shift_lua_stack", "lua_abilities/creature_slark_essence_shift_lua/modifier_creature_slark_essence_shift_lua_stack", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_slark_essence_shift_lua:GetIntrinsicModifierName()
    return "modifier_creature_slark_essence_shift_lua"
end