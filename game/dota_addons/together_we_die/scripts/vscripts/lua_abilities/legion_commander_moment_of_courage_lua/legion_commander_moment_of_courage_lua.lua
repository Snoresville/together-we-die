legion_commander_moment_of_courage_lua = class({})
LinkLuaModifier( "modifier_legion_commander_moment_of_courage_lua", "lua_abilities/legion_commander_moment_of_courage_lua/modifier_legion_commander_moment_of_courage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_legion_commander_moment_of_courage_lua_buff", "lua_abilities/legion_commander_moment_of_courage_lua/modifier_legion_commander_moment_of_courage_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function legion_commander_moment_of_courage_lua:GetIntrinsicModifierName()
	return "modifier_legion_commander_moment_of_courage_lua"
end