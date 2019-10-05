creature_enchantress_untouchable_lua = class({})
LinkLuaModifier( "modifier_creature_enchantress_untouchable_lua", "lua_abilities/creature_enchantress_untouchable_lua/modifier_creature_enchantress_untouchable_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_enchantress_untouchable_lua_debuff", "lua_abilities/creature_enchantress_untouchable_lua/modifier_creature_enchantress_untouchable_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_enchantress_untouchable_lua:GetIntrinsicModifierName()
	return "modifier_creature_enchantress_untouchable_lua"
end