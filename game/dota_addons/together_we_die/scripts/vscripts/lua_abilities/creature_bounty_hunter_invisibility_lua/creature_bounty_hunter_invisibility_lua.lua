creature_bounty_hunter_invisibility_lua = class({})
LinkLuaModifier( "modifier_creature_bounty_hunter_invisibility_lua", "lua_abilities/creature_bounty_hunter_invisibility_lua/modifier_creature_bounty_hunter_invisibility_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_bounty_hunter_invisibility_lua_buff", "lua_abilities/creature_bounty_hunter_invisibility_lua/modifier_creature_bounty_hunter_invisibility_lua_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function creature_bounty_hunter_invisibility_lua:GetIntrinsicModifierName()
	return "modifier_creature_bounty_hunter_invisibility_lua"
end