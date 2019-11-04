--------------------------------------------------------------------------------
creature_ogre_magi_multicast_lua = class({})
LinkLuaModifier( "modifier_creature_ogre_magi_multicast_lua", "lua_abilities/creature_ogre_magi_multicast_lua/modifier_creature_ogre_magi_multicast_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_ogre_magi_multicast_lua_proc", "lua_abilities/creature_ogre_magi_multicast_lua/modifier_creature_ogre_magi_multicast_lua_proc", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_ogre_magi_multicast_lua:GetIntrinsicModifierName()
	return "modifier_creature_ogre_magi_multicast_lua"
end