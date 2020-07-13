--------------------------------------------------------------------------------
perfect_stance_lua = class({})
LinkLuaModifier( "modifier_perfect_stance_lua", "lua_abilities/perfect_stance_lua/modifier_perfect_stance_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function perfect_stance_lua:GetIntrinsicModifierName()
	return "modifier_perfect_stance_lua"
end