--------------------------------------------------------------------------------
modifier_roshan_defective_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_defective_aura_lua:IsHidden()
	return not self:GetParent():PassivesDisabled() and self:GetParent():GetHealthPercent() > self.hp_percent
end

function modifier_roshan_defective_aura_lua:IsDebuff()
	return false
end

function modifier_roshan_defective_aura_lua:IsPurgable()
	return false
end

function modifier_roshan_defective_aura_lua:IsAura()
	return not self:GetParent():PassivesDisabled() and self:GetParent():GetHealthPercent() <= self.hp_percent
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:GetModifierAura()
	return "modifier_roshan_defective_aura_effect_lua"
end

--------------------------------------------------------------------------------
function modifier_roshan_defective_aura_lua:GetAuraRadius()
	return self.radius
end

function modifier_roshan_defective_aura_lua:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_roshan_defective_aura_lua:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end
--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:OnRefresh( kv )
end
