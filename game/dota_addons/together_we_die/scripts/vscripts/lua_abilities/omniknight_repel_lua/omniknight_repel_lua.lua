omniknight_repel_lua = class({})
LinkLuaModifier( "modifier_omniknight_repel_lua", "lua_abilities/omniknight_repel_lua/modifier_omniknight_repel_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function omniknight_repel_lua:GetIntrinsicModifierName()
	return "modifier_omniknight_repel_lua"
end