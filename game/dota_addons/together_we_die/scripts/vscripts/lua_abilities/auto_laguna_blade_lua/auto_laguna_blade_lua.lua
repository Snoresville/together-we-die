auto_laguna_blade_lua = class({})
LinkLuaModifier( "modifier_auto_laguna_blade_lua", "lua_abilities/auto_laguna_blade_lua/modifier_auto_laguna_blade_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function auto_laguna_blade_lua:GetIntrinsicModifierName()
	return "modifier_auto_laguna_blade_lua"
end
