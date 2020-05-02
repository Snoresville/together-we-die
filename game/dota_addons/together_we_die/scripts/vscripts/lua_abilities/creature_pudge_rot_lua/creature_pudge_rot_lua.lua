creature_pudge_rot_lua = class({})
LinkLuaModifier("modifier_creature_pudge_rot_lua", "lua_abilities/creature_pudge_rot_lua/modifier_creature_pudge_rot_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_pudge_rot_lua:GetIntrinsicModifierName()
    return "modifier_creature_pudge_rot_lua"
end

