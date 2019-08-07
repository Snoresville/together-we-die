intelligence_magic_scale_lua = class({})
LinkLuaModifier( "modifier_intelligence_magic_scale_lua", "lua_abilities/intelligence_magic_scale_lua/modifier_intelligence_magic_scale_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function intelligence_magic_scale_lua:GetIntrinsicModifierName()
	return "modifier_intelligence_magic_scale_lua"
end
