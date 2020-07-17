modifier_invoker_exort_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_exort_lua:IsHidden()
	return false
end

function modifier_invoker_exort_lua:IsDebuff()
	return false
end

function modifier_invoker_exort_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_invoker_exort_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_exort_lua:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_instance" ) -- special value
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )
	self.amp_int_multiplier = self:GetAbility():GetSpecialValueFor( "amp_int_multiplier" )
end

function modifier_invoker_exort_lua:OnRefresh( kv )
	self:OnCreated(kv)
end

function modifier_invoker_exort_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_exort_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end
function modifier_invoker_exort_lua:GetModifierPreAttack_BonusDamage()
	return self.damage + self:GetParent():GetIntellect() * self.int_multiplier
end

function modifier_invoker_exort_lua:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():GetModifierStackCount("modifier_invoker_exort_amp_lua", self:GetCaster()) == 1 then
		return math.floor(self:GetParent():GetIntellect() * self.amp_int_multiplier)
	end
	return 0
end