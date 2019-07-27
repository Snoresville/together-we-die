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
summoning_stone_lua = class({})
LinkLuaModifier( "modifier_summoning_stone_lua", "lua_abilities/summoning_stone_lua/modifier_summoning_stone_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summoning_stone_effect_lua", "lua_abilities/summoning_stone_lua/modifier_summoning_stone_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function summoning_stone_lua:GetIntrinsicModifierName()
	return "modifier_summoning_stone_lua"
end
