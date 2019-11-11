item_assault_lua = class({})
LinkLuaModifier( "modifier_item_assault_lua", "lua_abilities/item_assault_lua/modifier_item_assault_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_assault_effect_lua", "lua_abilities/item_assault_lua/modifier_item_assault_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function item_assault_lua:GetIntrinsicModifierName()
	return "modifier_item_assault_lua"
end

item_assault2_lua = class(item_assault_lua)