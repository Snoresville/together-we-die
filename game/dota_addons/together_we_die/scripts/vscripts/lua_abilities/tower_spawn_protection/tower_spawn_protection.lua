tower_spawn_protection = class({})
LinkLuaModifier( "modifier_tower_spawn_protection", "lua_abilities/tower_spawn_protection/modifier_tower_spawn_protection", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function tower_spawn_protection:GetIntrinsicModifierName()
	return "modifier_tower_spawn_protection"
end
