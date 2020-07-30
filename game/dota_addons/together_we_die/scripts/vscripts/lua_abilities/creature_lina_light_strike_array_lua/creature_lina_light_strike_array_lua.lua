creature_lina_light_strike_array_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_lina_light_strike_array_lua", "lua_abilities/creature_lina_light_strike_array_lua/modifier_creature_lina_light_strike_array_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function creature_lina_light_strike_array_lua:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------
-- Ability Start
function creature_lina_light_strike_array_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_creature_lina_light_strike_array_lua", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end