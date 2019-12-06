modifier_invoker_emp_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_emp_lua:IsHidden()
	return false
end

function modifier_invoker_emp_lua:IsDebuff()
	return true
end

function modifier_invoker_emp_lua:IsPurgable()
	return false
end

function modifier_invoker_emp_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_emp_lua:OnCreated( kv )
	-- references
	self.mana_loss = self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "leak_int_multiplier")
end

function modifier_invoker_emp_lua:OnRefresh( kv )
	-- references
	self.mana_loss = self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "leak_int_multiplier")
end

function modifier_invoker_emp_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_emp_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end
function modifier_invoker_emp_lua:GetModifierConstantManaRegen()
	return -self.mana_loss
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_invoker_emp_lua:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf"
end

function modifier_invoker_emp_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
