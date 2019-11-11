modifier_item_assault_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_assault_lua:IsHidden()
	return true
end

function modifier_item_assault_lua:IsPurgable()
	return false
end

function modifier_item_assault_lua:IsAura()
	return true
end

function modifier_item_assault_lua:GetModifierAura()
	return "modifier_item_assault_effect_lua"
end

function modifier_item_assault_lua:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_assault_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_assault_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_assault_lua:OnCreated( kv )
	-- references
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end

function modifier_item_assault_lua:OnRefresh( kv )
	-- references
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

	self:OnIntervalThink()
end

function modifier_item_assault_lua:OnDestroy( kv )

end

function modifier_item_assault_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Modifier Effects
function modifier_item_assault_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_item_assault_lua:GetModifierPhysicalArmorBonus()
	return self.bonus_armor + self:GetStackCount()
end

function modifier_item_assault_lua:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.floor(self:GetCaster():GetPrimaryStatValue() * self.primary_attr_multiplier))
	end
end

function modifier_item_assault_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end