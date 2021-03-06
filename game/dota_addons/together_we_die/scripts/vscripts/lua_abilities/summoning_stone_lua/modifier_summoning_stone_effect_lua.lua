modifier_summoning_stone_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_summoning_stone_effect_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_effect_lua:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_int_multiplier = self:GetAbility():GetSpecialValueFor( "health_int_multiplier" )
	self.damage_int_multiplier = self:GetAbility():GetSpecialValueFor( "damage_int_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_effect_lua:OnRefresh( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_int_multiplier = self:GetAbility():GetSpecialValueFor( "health_int_multiplier" )
	self.damage_int_multiplier = self:GetAbility():GetSpecialValueFor( "damage_int_multiplier" )
end


--------------------------------------------------------------------------------

function modifier_summoning_stone_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_effect_lua:GetModifierPreAttack_BonusDamage( params )
	if not self:GetCaster():PassivesDisabled() then
		return self.bonus_damage + math.floor(self.damage_int_multiplier * self:GetCaster():GetIntellect())
	end

	return 0
end

function modifier_summoning_stone_effect_lua:GetModifierPhysicalArmorBonus( params )
	if not self:GetCaster():PassivesDisabled() then
		return self.bonus_armor
	end

	return 0
end

function modifier_summoning_stone_effect_lua:GetModifierExtraHealthBonus( params )
	if not self:GetCaster():PassivesDisabled() then
		return self.bonus_health + math.floor(self.health_int_multiplier * self:GetCaster():GetIntellect())
	end

	return 0
end

--------------------------------------------------------------------------------

