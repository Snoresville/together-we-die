modifier_bad_guy_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bad_guy_lua:IsHidden()
	return true
end

function modifier_bad_guy_lua:IsDebuff()
	return false
end

function modifier_bad_guy_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bad_guy_lua:OnCreated( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
end

function modifier_bad_guy_lua:OnRefresh( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bad_guy_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_bad_guy_lua:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction
end

function modifier_bad_guy_lua:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage_pct
end

function modifier_bad_guy_lua:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end
