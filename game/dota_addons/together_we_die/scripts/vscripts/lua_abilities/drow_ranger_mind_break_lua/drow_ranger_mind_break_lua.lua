drow_ranger_mind_break_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_silenced_lua", "lua_abilities/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_drow_ranger_mind_break_lua", "lua_abilities/drow_ranger_mind_break_lua/modifier_drow_ranger_mind_break_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function drow_ranger_mind_break_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	local special_mind_break_duration_lua = caster:FindAbilityByName("special_mind_break_duration_lua")
	if (special_mind_break_duration_lua and special_mind_break_duration_lua:GetLevel() ~= 0) then
		duration = duration + special_mind_break_duration_lua:GetSpecialValueFor("value")
	end
	-- self buff
	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_drow_ranger_mind_break_lua", -- modifier name
			{ duration = duration } -- kv
	)
end