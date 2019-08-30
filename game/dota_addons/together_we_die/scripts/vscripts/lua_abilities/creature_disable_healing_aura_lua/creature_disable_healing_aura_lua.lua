--------------------------------------------------------------------------------
creature_disable_healing_aura_lua = class({})
LinkLuaModifier( "modifier_creature_disable_healing_aura_lua", "lua_abilities/creature_disable_healing_aura_lua/modifier_creature_disable_healing_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_disable_healing_aura_effect_lua", "lua_abilities/creature_disable_healing_aura_lua/modifier_creature_disable_healing_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_disable_healing_aura_lua:GetIntrinsicModifierName()
	return "modifier_creature_disable_healing_aura_lua"
end
