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
creature_timbersaw_reactive_armor_lua = class({})
LinkLuaModifier( "modifier_creature_timbersaw_reactive_armor_lua", "lua_abilities/creature_timbersaw_reactive_armor_lua/modifier_creature_timbersaw_reactive_armor_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_timbersaw_reactive_armor_lua_stack", "lua_abilities/creature_timbersaw_reactive_armor_lua/modifier_creature_timbersaw_reactive_armor_lua_stack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_timbersaw_reactive_armor_lua:GetIntrinsicModifierName()
	return "modifier_creature_timbersaw_reactive_armor_lua"
end