--------------------------------------------------------------------------------
roshan_defective_aura_lua = class({})
LinkLuaModifier( "modifier_roshan_defective_aura_lua", "lua_abilities/roshan_defective_aura_lua/modifier_roshan_defective_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_defective_aura_effect_lua", "lua_abilities/roshan_defective_aura_lua/modifier_roshan_defective_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_defective_aura_lua:GetIntrinsicModifierName()
	return "modifier_roshan_defective_aura_lua"
end
