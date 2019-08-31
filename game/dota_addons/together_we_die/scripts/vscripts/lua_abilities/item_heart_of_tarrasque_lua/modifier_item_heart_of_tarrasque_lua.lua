modifier_item_heart_of_tarrasque_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_heart_of_tarrasque_lua:IsHidden()
	return true
end

function modifier_item_heart_of_tarrasque_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_heart_of_tarrasque_lua:OnCreated( kv )
	-- references
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.hp_regen_amp = self:GetAbility():GetSpecialValueFor( "hp_regen_amp" )
	self.health_regen_rate = self:GetAbility():GetSpecialValueFor( "health_regen_rate" )
	self.hurt_cooldown = self:GetAbility():GetSpecialValueFor( "hurt_cooldown" )
end

function modifier_item_heart_of_tarrasque_lua:OnRefresh( kv )

end

function modifier_item_heart_of_tarrasque_lua:OnDestroy( kv )

end

function modifier_item_heart_of_tarrasque_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_heart_of_tarrasque_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_item_heart_of_tarrasque_lua:OnTakeDamage( params )
	if IsServer() and params.unit == self:GetParent() and params.attacker ~= self:GetParent() then
		-- cooldown
		self:GetAbility():StartCooldown( self.hurt_cooldown )
	end
end

function modifier_item_heart_of_tarrasque_lua:GetModifierHealthBonus( params )
	return self.bonus_health
end

function modifier_item_heart_of_tarrasque_lua:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

function modifier_item_heart_of_tarrasque_lua:GetModifierHealthRegenPercentage( params )
	if IsServer() and not self:GetParent():PassivesDisabled() and self:GetAbility():IsCooldownReady() then
		return self.health_regen_rate
	end

	return 0
end

function modifier_item_heart_of_tarrasque_lua:GetModifierHPRegenAmplify_Percentage( params )
	if IsServer() and not self:GetParent():PassivesDisabled() and self:GetAbility():IsCooldownReady() then
		return self.hp_regen_amp
	end

	return 0
end