-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
dazzle_bad_juju_lua = class({})
LinkLuaModifier("modifier_dazzle_bad_juju_lua", "lua_abilities/dazzle_bad_juju_lua/modifier_dazzle_bad_juju_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_bad_juju_lua_debuff", "lua_abilities/dazzle_bad_juju_lua/modifier_dazzle_bad_juju_lua_debuff", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
function dazzle_bad_juju_lua:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Passive Modifier
function dazzle_bad_juju_lua:GetIntrinsicModifierName()
    return "modifier_dazzle_bad_juju_lua"
end
