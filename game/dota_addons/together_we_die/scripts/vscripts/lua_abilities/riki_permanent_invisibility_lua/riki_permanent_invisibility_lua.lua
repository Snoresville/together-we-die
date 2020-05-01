riki_permanent_invisibility_lua = class({})
LinkLuaModifier( "modifier_riki_permanent_invisibility_lua", "lua_abilities/riki_permanent_invisibility_lua/modifier_riki_permanent_invisibility_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_permanent_invisibility_lua_buff", "lua_abilities/riki_permanent_invisibility_lua/modifier_riki_permanent_invisibility_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function riki_permanent_invisibility_lua:GetIntrinsicModifierName()
	return "modifier_riki_permanent_invisibility_lua"
end