creature_treant_king_armor_aura_lua = class({})
LinkLuaModifier( "modifier_creature_treant_king_armor_aura_lua", "lua_abilities/creature_treant_king_armor_aura_lua/modifier_creature_treant_king_armor_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_treant_king_armor_aura_effect_lua", "lua_abilities/creature_treant_king_armor_aura_lua/modifier_creature_treant_king_armor_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_treant_king_armor_aura_lua:GetIntrinsicModifierName()
	return "modifier_creature_treant_king_armor_aura_lua"
end