centaur_warrunner_return_lua = class({})
LinkLuaModifier( "modifier_centaur_warrunner_return_lua", "lua_abilities/centaur_warrunner_return_lua/modifier_centaur_warrunner_return_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_warrunner_return_lua_effect", "lua_abilities/centaur_warrunner_return_lua/modifier_centaur_warrunner_return_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function centaur_warrunner_return_lua:GetIntrinsicModifierName()
	return "modifier_centaur_warrunner_return_lua"
end