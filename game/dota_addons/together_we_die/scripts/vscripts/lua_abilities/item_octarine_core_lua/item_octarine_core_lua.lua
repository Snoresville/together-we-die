item_octarine_core_lua = class({})
LinkLuaModifier( "modifier_item_octarine_core_lua", "lua_abilities/item_octarine_core_lua/modifier_item_octarine_core_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function item_octarine_core_lua:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua"
end