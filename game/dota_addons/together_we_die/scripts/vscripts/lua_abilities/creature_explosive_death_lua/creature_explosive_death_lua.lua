creature_explosive_death_lua = class({})
LinkLuaModifier( "modifier_creature_explosive_death_lua", "lua_abilities/creature_explosive_death_lua/modifier_creature_explosive_death_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_explosive_death_lua:GetIntrinsicModifierName()
	return "modifier_creature_explosive_death_lua"
end