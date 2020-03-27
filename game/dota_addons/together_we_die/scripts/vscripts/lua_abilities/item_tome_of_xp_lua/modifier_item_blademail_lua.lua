modifier_item_blademail_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_blademail_lua:IsHidden()
	return true
end

function modifier_item_blademail_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_blademail_lua:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_blademail_lua:OnRefresh( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_blademail_lua:OnDestroy( kv )

end

function modifier_item_blademail_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Modifier Effects
function modifier_item_blademail_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_item_blademail_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_blademail_lua:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_blademail_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end