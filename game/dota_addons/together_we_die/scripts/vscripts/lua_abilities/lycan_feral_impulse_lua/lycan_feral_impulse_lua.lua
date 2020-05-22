lycan_feral_impulse_lua = class({})
LinkLuaModifier( "modifier_lycan_feral_impulse_lua", "lua_abilities/lycan_feral_impulse_lua/modifier_lycan_feral_impulse_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_feral_impulse_lua_aura", "lua_abilities/lycan_feral_impulse_lua/modifier_lycan_feral_impulse_lua_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function lycan_feral_impulse_lua:GetIntrinsicModifierName()
	return "modifier_lycan_feral_impulse_lua"
end