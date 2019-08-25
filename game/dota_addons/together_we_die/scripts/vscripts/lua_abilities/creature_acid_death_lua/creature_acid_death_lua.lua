--------------------------------------------------------------------------------
creature_acid_death_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_creature_acid_death_lua", "lua_abilities/creature_acid_death_lua/modifier_creature_acid_death_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_acid_death_aura_lua", "lua_abilities/creature_acid_death_lua/modifier_creature_acid_death_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_acid_death_effect_lua", "lua_abilities/creature_acid_death_lua/modifier_creature_acid_death_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_acid_death_lua:GetIntrinsicModifierName()
	return "modifier_creature_acid_death_lua"
end
