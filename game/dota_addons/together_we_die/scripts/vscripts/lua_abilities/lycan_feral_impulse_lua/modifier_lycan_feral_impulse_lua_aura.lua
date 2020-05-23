modifier_lycan_feral_impulse_lua_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_feral_impulse_lua_aura:IsHidden()
	return false
end

function modifier_lycan_feral_impulse_lua_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lycan_feral_impulse_lua_aura:OnCreated( kv )
	self:StartIntervalThink(1)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lycan_feral_impulse_lua_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_lycan_feral_impulse_lua_aura:GetModifierBaseDamageOutgoing_Percentage()
	if not IsServer() then return end
	return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "bonus_damage_increase_per_strength" )  -- special value
end

function modifier_lycan_feral_impulse_lua_aura:GetModifierConstantHealthRegen()
	if not IsServer() then return end
	return self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" ) + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "bonus_hp_regen_increase_per_strength" ) -- special value
end

function modifier_lycan_feral_impulse_lua_aura:OnIntervalThink()
	if not IsServer() then return end
	self:ForceRefresh()
end