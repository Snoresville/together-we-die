modifier_slark_shadow_dance_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua_buff:IsHidden()
    return false
end

function modifier_slark_shadow_dance_lua_buff:IsDebuff()
    return false
end

function modifier_slark_shadow_dance_lua_buff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua_buff:OnCreated(kv)
    -- references
    self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen_pct") -- special value
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") -- special value
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
end

function modifier_slark_shadow_dance_lua_buff:OnRefresh(kv)
    -- references
    self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen_pct") -- special value
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") -- special value
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
end

function modifier_slark_shadow_dance_lua_buff:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_shadow_dance_lua_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }

    return funcs
end

function modifier_slark_shadow_dance_lua_buff:GetModifierHealthRegenPercentage()
    return self.bonus_regen
end
function modifier_slark_shadow_dance_lua_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.bonus_movespeed
end
function modifier_slark_shadow_dance_lua_buff:GetModifierBaseAttack_BonusDamage()
    return self.agi_multiplier * self:GetCaster():GetAgility()
end
