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
medusa_mana_shield_lua = class({})
LinkLuaModifier( "modifier_medusa_mana_shield_lua", "lua_abilities/medusa_mana_shield_lua/modifier_medusa_mana_shield_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_medusa_mana_shield_hp_regen_lua", "lua_abilities/medusa_mana_shield_lua/modifier_medusa_mana_shield_hp_regen_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function medusa_mana_shield_lua:GetIntrinsicModifierName()
	return "modifier_medusa_mana_shield_hp_regen_lua"
end
--------------------------------------------------------------------------------
-- Ability Start
function medusa_mana_shield_lua:OnSpellStart()
end
--------------------------------------------------------------------------------
-- Toggle
function medusa_mana_shield_lua:OnToggle()
	-- unit identifier
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName( "modifier_medusa_mana_shield_lua" )

	if self:GetToggleState() then
		if not modifier then
			caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_medusa_mana_shield_lua", -- modifier name
				{} -- kv
			)
		end
	else
		if modifier then
			modifier:Destroy()
		end
	end
end
function medusa_mana_shield_lua:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------
-- Ability Events
function medusa_mana_shield_lua:OnUpgrade()
	-- refresh values if on
	local modifier = self:GetCaster():FindModifierByName( "modifier_medusa_mana_shield_lua" )
	if modifier then
		modifier:ForceRefresh()
	end
end