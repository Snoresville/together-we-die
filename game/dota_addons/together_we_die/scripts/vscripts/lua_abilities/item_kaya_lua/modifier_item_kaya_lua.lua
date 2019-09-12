modifier_item_kaya_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_kaya_lua:IsHidden()
	return true
end

function modifier_item_kaya_lua:IsPurgable()
	return false
end

function modifier_item_kaya_lua:IsAura()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_kaya_lua:OnCreated( kv )
	-- references
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.strength_reduction = self:GetAbility():GetSpecialValueFor( "strength_reduction" )
	self.agility_reduction = self:GetAbility():GetSpecialValueFor( "agility_reduction" )
end

function modifier_item_kaya_lua:OnRefresh( kv )
	-- references
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.strength_reduction = self:GetAbility():GetSpecialValueFor( "strength_reduction" )
	self.agility_reduction = self:GetAbility():GetSpecialValueFor( "agility_reduction" )
end

function modifier_item_kaya_lua:OnDestroy( kv )

end

function modifier_item_kaya_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE
end

-- Modifier Effects
function modifier_item_kaya_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_item_kaya_lua:GetModifierBonusStats_Strength()
	return self.strength_reduction
end

function modifier_item_kaya_lua:GetModifierBonusStats_Agility()
	return self.agility_reduction
end

function modifier_item_kaya_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_kaya_lua:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end