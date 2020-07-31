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
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	self.exp_boost = self:GetAbility():GetSpecialValueFor( "exp_boost" )
end

function modifier_difficulty_lua_effect:OnRefresh( kv )
	-- references
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	self.exp_boost = self:GetAbility():GetSpecialValueFor( "exp_boost" )
end

function modifier_difficulty_lua_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_difficulty_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}

	return funcs
end

function modifier_difficulty_lua_effect:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end

function modifier_difficulty_lua_effect:GetModifierPercentageExpRateBoost()
	return self.exp_boost
end