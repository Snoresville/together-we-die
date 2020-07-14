lycan_wolf_mastery_lua = class({})
LinkLuaModifier( "modifier_lycan_wolf_mastery_lua", "lua_abilities/lycan_wolf_mastery_lua/modifier_lycan_wolf_mastery_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function lycan_wolf_mastery_lua:GetIntrinsicModifierName()
	return "modifier_lycan_wolf_mastery_lua"
end