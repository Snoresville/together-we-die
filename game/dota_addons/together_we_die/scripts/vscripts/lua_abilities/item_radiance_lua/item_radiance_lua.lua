item_radiance_lua = class({})
LinkLuaModifier( "modifier_item_radiance_lua", "lua_abilities/item_radiance_lua/modifier_item_radiance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_radiance_effect_lua", "lua_abilities/item_radiance_lua/modifier_item_radiance_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function item_radiance_lua:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua"
end

item_radiance2_lua = class(item_radiance_lua)