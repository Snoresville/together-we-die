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
modifier_timbersaw_reactive_armor_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_timbersaw_reactive_armor_lua_stack:IsHidden()
	return false
end

function modifier_timbersaw_reactive_armor_lua_stack:IsPurgable()
	return false
end

function modifier_timbersaw_reactive_armor_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_timbersaw_reactive_armor_lua_stack:OnCreated( kv )
	-- references
	self.str_bonus = self:GetAbility():GetSpecialValueFor( "str_multiplier" ) * self:GetParent():GetStrength()
	self.stack_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" ) + self.str_bonus
	self.stack_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) + self.str_bonus/40
	self.stack_limit = math.floor(self:GetAbility():GetSpecialValueFor( "stack_limit" ) + self.str_bonus)
end

function modifier_timbersaw_reactive_armor_lua_stack:OnRefresh( kv )
	-- references
	self.str_bonus = self:GetAbility():GetSpecialValueFor( "str_multiplier" ) * self:GetParent():GetStrength()
	self.stack_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" ) + self.str_bonus
	self.stack_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) + self.str_bonus/40
	self.stack_limit = math.floor(self:GetAbility():GetSpecialValueFor( "stack_limit" ) + self.str_bonus)
	if self:GetStackCount()<self.stack_limit then
		self:IncrementStackCount()
	end
end

function modifier_timbersaw_reactive_armor_lua_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_timbersaw_reactive_armor_lua_stack:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.stack_armor
end
function modifier_timbersaw_reactive_armor_lua_stack:GetModifierConstantHealthRegen()
	return self:GetStackCount() * self.stack_regen
end