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
function modifier_lycan_feral_impulse_lua_aura:OnCreated(kv)
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_lycan_feral_impulse_lua_aura:OnRefresh(kv)
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
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
    return self.bonus_damage + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("bonus_damage_increase_per_strength")
end

function modifier_lycan_feral_impulse_lua_aura:GetModifierConstantHealthRegen()
    return self.bonus_hp_regen + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("bonus_hp_regen_increase_per_strength")
end