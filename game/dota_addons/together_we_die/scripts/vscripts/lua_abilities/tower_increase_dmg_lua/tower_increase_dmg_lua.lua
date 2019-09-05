tower_increase_dmg_lua = class({})
LinkLuaModifier( "modifier_tower_increase_dmg_lua", "lua_abilities/tower_increase_dmg_lua/modifier_tower_increase_dmg_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_increase_dmg_debuff_lua", "lua_abilities/tower_increase_dmg_lua/modifier_tower_increase_dmg_debuff_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function tower_increase_dmg_lua:GetIntrinsicModifierName()
	return "modifier_tower_increase_dmg_lua"
end
