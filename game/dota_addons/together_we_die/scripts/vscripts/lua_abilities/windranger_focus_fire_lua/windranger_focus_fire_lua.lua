-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
windranger_focus_fire_lua = class({})
LinkLuaModifier( "modifier_windranger_focus_fire_lua", "lua_abilities/windranger_focus_fire_lua/modifier_windranger_focus_fire_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function windranger_focus_fire_lua:GetDuration()
	return self:GetSpecialValueFor( "focusfire_duration_tooltip" ) + self:GetCaster():GetIntellect() * self:GetSpecialValueFor( "int_multiplier" )
end
-- Ability Start
function windranger_focus_fire_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- add modifier to new targets
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_windranger_focus_fire_lua", -- modifier name
		{
			duration = duration,
		} -- kv
	)

	-- Play effects
	local sound_cast = "Ability.Focusfire"
	EmitSoundOn( sound_cast, caster )
end