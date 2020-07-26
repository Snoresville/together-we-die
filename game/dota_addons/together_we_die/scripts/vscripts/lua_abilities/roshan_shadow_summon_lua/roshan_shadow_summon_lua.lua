roshan_shadow_summon_lua = class({})
LinkLuaModifier( "modifier_roshan_shadow_summon_lua", "lua_abilities/roshan_shadow_summon_lua/modifier_roshan_shadow_summon_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_shadow_summon_invulnerable_lua", "lua_abilities/roshan_shadow_summon_lua/modifier_roshan_shadow_summon_invulnerable_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_shadow_summon_lua:GetIntrinsicModifierName()
	return "modifier_roshan_shadow_summon_lua"
end