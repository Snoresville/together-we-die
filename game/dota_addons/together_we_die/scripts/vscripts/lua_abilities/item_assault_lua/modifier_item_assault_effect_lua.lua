modifier_item_assault_effect_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_assault_effect_lua:IsHidden()
	return false
end

function modifier_item_assault_effect_lua:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_item_assault_effect_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_assault_effect_lua:OnCreated( kv )
	-- references
	self.aura_attack_speed = self:GetAbility():GetSpecialValueFor( "aura_attack_speed" )
	self.aura_negative_armor = self:GetAbility():GetSpecialValueFor( "aura_negative_armor" )
	self.aura_positive_armor = self:GetAbility():GetSpecialValueFor( "aura_positive_armor" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )

	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end

function modifier_item_assault_effect_lua:OnRefresh( kv )
	-- references
	self.aura_attack_speed = self:GetAbility():GetSpecialValueFor( "aura_attack_speed" )
	self.aura_negative_armor = self:GetAbility():GetSpecialValueFor( "aura_negative_armor" )
	self.aura_positive_armor = self:GetAbility():GetSpecialValueFor( "aura_positive_armor" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )

	self:OnIntervalThink()
end

function modifier_item_assault_effect_lua:OnDestroy( kv )

end

function modifier_item_assault_effect_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_assault_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_item_assault_effect_lua:GetModifierPhysicalArmorBonus()
	if (self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()) then
		return self.aura_negative_armor - self:GetStackCount()
	end
	return self.aura_positive_armor + self:GetStackCount()
end

function modifier_item_assault_effect_lua:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.floor(self:GetCaster():GetPrimaryStatValue() * self.primary_attr_multiplier))
	end
end

function modifier_item_assault_effect_lua:GetModifierAttackSpeedBonus_Constant()
	if (self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber()) then
		return self.aura_attack_speed
	end

	return 0
end