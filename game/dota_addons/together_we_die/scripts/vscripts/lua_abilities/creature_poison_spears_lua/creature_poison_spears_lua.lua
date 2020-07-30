creature_poison_spears_lua = class({})
LinkLuaModifier( "modifier_creature_poison_spears_lua", "lua_abilities/creature_poison_spears_lua/modifier_creature_poison_spears_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_poison_spears_lua_debuff", "lua_abilities/creature_poison_spears_lua/modifier_creature_poison_spears_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_poison_spears_lua:GetIntrinsicModifierName()
	return "modifier_creature_poison_spears_lua"
end

creature_greater_poison_spears_lua = class(creature_poison_spears_lua)