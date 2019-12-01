difficulty_lua = class({})
LinkLuaModifier( "modifier_difficulty_lua", "lua_abilities/gamemode/difficulty_lua/modifier_difficulty_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_difficulty_lua_effect", "lua_abilities/gamemode/difficulty_lua/modifier_difficulty_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function difficulty_lua:GetIntrinsicModifierName()
	return "modifier_difficulty_lua"
end

easy_difficulty_lua = class(difficulty_lua)
normal_difficulty_lua = class(difficulty_lua)
hard_difficulty_lua = class(difficulty_lua)
impossible_difficulty_lua = class(difficulty_lua)