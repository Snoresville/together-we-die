riki_backstab_lua = class({})
LinkLuaModifier( "modifier_riki_backstab_lua", "lua_abilities/riki_backstab_lua/modifier_riki_backstab_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function riki_backstab_lua:GetIntrinsicModifierName()
	return "modifier_riki_backstab_lua"
end