modifier_difficulty_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_difficulty_lua_effect:IsHidden()
	return false
end

function modifier_difficulty_lua_effect:IsDebuff()
	return false
end

function modifier_difficulty_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_difficulty_lua_effect:OnCreated( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	self.exp_boost = self:GetAbility():GetSpecialValueFor( "exp_boost" )
end

function modifier_difficulty_lua_effect:OnRefresh( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	self.exp_boost = self:GetAbility():GetSpecialValueFor( "exp_boost" )
end

function modifier_difficulty_lua_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_difficulty_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}

	return funcs
end

function modifier_difficulty_lua_effect:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction
end

function modifier_difficulty_lua_effect:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage_pct
end

function modifier_difficulty_lua_effect:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end

function modifier_difficulty_lua_effect:GetModifierPercentageExpRateBoost()
	return self.exp_boost
end