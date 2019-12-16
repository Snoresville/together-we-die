modifier_tower_increase_dmg_debuff_lua = class({})

--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_debuff_lua:IsHidden()
	return false
end

function modifier_tower_increase_dmg_debuff_lua:IsDebuff()
	return true
end

function modifier_tower_increase_dmg_debuff_lua:IsPurgable()
	return false
end

function modifier_tower_increase_dmg_debuff_lua:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_debuff_lua:OnCreated( kv )
	self.mana_loss_per_stack = self:GetAbility():GetSpecialValueFor("mana_loss_per_stack")
	self:SetStackCount(1)
end

function modifier_tower_increase_dmg_debuff_lua:OnRefresh( kv )
	self.mana_loss_per_stack = self:GetAbility():GetSpecialValueFor("mana_loss_per_stack")
end

function modifier_tower_increase_dmg_debuff_lua:GetModifierConstantManaRegen()
	return -(self:GetStackCount() * self.mana_loss_per_stack)
end

function modifier_tower_increase_dmg_debuff_lua:GetDisableHealing( params )
	return 1
end

function modifier_tower_increase_dmg_debuff_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tower_increase_dmg_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_tower_increase_dmg_debuff_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end