--------------------------------------------------------------------------------
creature_chaos_protect_light_lua = class({})
LinkLuaModifier( "modifier_creature_chaos_protect_light_lua", "lua_abilities/creature_chaos_protect_light_lua/modifier_creature_chaos_protect_light_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_chaos_protect_light_effect_lua", "lua_abilities/creature_chaos_protect_light_lua/modifier_creature_chaos_protect_light_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_chaos_protect_light_lua:GetIntrinsicModifierName()
	return "modifier_creature_chaos_protect_light_lua"
end
