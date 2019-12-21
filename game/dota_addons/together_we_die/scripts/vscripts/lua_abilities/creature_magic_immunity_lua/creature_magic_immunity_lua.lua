creature_magic_immunity_lua = class({})
LinkLuaModifier( "modifier_creature_magic_immunity_lua", "lua_abilities/creature_magic_immunity_lua/modifier_creature_magic_immunity_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creature_magic_immunity_lua:GetIntrinsicModifierName()
	return "modifier_creature_magic_immunity_lua"
end