bad_guy_lua = class({})
LinkLuaModifier( "modifier_bad_guy_lua", "lua_abilities/gamemode/bad_guy_lua/modifier_bad_guy_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function bad_guy_lua:GetIntrinsicModifierName()
	return "modifier_bad_guy_lua"
end
