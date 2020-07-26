--------------------------------------------------------------------------------
roshan_armor_reverse_aura_lua = class({})
LinkLuaModifier( "modifier_roshan_armor_reverse_aura_lua", "lua_abilities/roshan_armor_reverse_aura_lua/modifier_roshan_armor_reverse_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_armor_reverse_aura_lua_effect", "lua_abilities/roshan_armor_reverse_aura_lua/modifier_roshan_armor_reverse_aura_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function roshan_armor_reverse_aura_lua:GetIntrinsicModifierName()
	return "modifier_roshan_armor_reverse_aura_lua"
end
