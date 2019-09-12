item_kaya4_lua = class({})
LinkLuaModifier( "modifier_item_kaya_lua", "lua_abilities/item_kaya_lua/modifier_item_kaya_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function item_kaya4_lua:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua"
end