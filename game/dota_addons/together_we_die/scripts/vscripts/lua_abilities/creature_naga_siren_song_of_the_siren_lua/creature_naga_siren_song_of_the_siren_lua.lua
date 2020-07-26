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
creature_naga_siren_song_of_the_siren_lua = class({})
LinkLuaModifier( "modifier_creature_naga_siren_song_of_the_siren_lua", "lua_abilities/creature_naga_siren_song_of_the_siren_lua/modifier_creature_naga_siren_song_of_the_siren_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_naga_siren_song_of_the_siren_lua_debuff", "lua_abilities/creature_naga_siren_song_of_the_siren_lua/modifier_creature_naga_siren_song_of_the_siren_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function creature_naga_siren_song_of_the_siren_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- create aura
	 caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creature_naga_siren_song_of_the_siren_lua", -- modifier name
		{ duration = duration } -- kv
	)
end