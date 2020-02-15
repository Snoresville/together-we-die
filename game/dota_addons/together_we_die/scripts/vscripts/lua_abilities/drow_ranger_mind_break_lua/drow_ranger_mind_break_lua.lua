drow_ranger_mind_break_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_silenced_lua", "lua_abilities/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_drow_ranger_mind_break_lua", "lua_abilities/drow_ranger_mind_break_lua/modifier_drow_ranger_mind_break_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function drow_ranger_mind_break_lua:GetIntrinsicModifierName()
	return "modifier_drow_ranger_mind_break_lua"
end