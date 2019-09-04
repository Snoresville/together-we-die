luna_lunar_blessing_lua = class({})
LinkLuaModifier( "modifier_luna_lunar_blessing_lua", "lua_abilities/luna_lunar_blessing_lua/modifier_luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function luna_lunar_blessing_lua:GetIntrinsicModifierName()
	return "modifier_luna_lunar_blessing_lua"
end