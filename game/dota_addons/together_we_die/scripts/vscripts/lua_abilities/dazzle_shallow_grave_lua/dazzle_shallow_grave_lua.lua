dazzle_shallow_grave_lua = class({})
LinkLuaModifier( "modifier_dazzle_shallow_grave_lua", "lua_abilities/dazzle_shallow_grave_lua/modifier_dazzle_shallow_grave_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function dazzle_shallow_grave_lua:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "scepter_radius" )
	end

	return 0
end

--------------------------------------------------------------------------------
-- Ability Start
function dazzle_shallow_grave_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor("duration_tooltip")

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dazzle_shallow_grave_lua", -- modifier name
		{ duration = duration } -- kv
	)
end