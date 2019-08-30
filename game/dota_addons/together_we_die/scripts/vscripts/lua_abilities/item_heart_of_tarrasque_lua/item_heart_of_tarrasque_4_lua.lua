item_heart_of_tarrasque_4_lua = class({})
LinkLuaModifier( "modifier_item_heart_of_tarrasque_lua", "lua_abilities/item_heart_of_tarrasque_lua/modifier_item_heart_of_tarrasque_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function item_heart_of_tarrasque_4_lua:GetIntrinsicModifierName()
	return "modifier_item_heart_of_tarrasque_lua"
end