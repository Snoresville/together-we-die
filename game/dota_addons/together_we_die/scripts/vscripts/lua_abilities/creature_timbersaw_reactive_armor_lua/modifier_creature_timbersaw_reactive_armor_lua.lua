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
modifier_creature_timbersaw_reactive_armor_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_timbersaw_reactive_armor_lua:IsHidden()
	return true
end

function modifier_creature_timbersaw_reactive_armor_lua:IsDebuff()
	return false
end

function modifier_creature_timbersaw_reactive_armor_lua:IsStunDebuff()
	return false
end

function modifier_creature_timbersaw_reactive_armor_lua:IsPurgable()
	return false
end

function modifier_creature_timbersaw_reactive_armor_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_timbersaw_reactive_armor_lua:OnCreated( kv )
	-- references
	self.stack_duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
end

function modifier_creature_timbersaw_reactive_armor_lua:OnRefresh( kv )
	-- references
	self.stack_duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
end

function modifier_creature_timbersaw_reactive_armor_lua:OnRemoved()
end

function modifier_creature_timbersaw_reactive_armor_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_timbersaw_reactive_armor_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_creature_timbersaw_reactive_armor_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack modifier
	local modifier = self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_creature_timbersaw_reactive_armor_lua_stack", -- modifier name
		{ duration = self.stack_duration } -- kv
	)
end