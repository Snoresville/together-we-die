modifier_sniper_take_aim_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_take_aim_lua:IsHidden()
    return true
end

function modifier_sniper_take_aim_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_take_aim_lua:OnCreated(kv)
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    -- use stack system
    if not IsServer() then
        return
    end
    -- start interval
    self:OnIntervalThink()
    local interval = 1
    self:StartIntervalThink(interval)
end

function modifier_sniper_take_aim_lua:OnRefresh(kv)
    -- references
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_sniper_take_aim_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_take_aim_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }

    return funcs
end
function modifier_sniper_take_aim_lua:GetModifierAttackRangeBonus()
    if not self:GetParent():PassivesDisabled() then
        return self:GetStackCount()
    end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_take_aim_lua:OnIntervalThink()
    local agi_multiplier = self.agi_multiplier
    local bonus_attack_range = self.bonus_attack_range
    -- Talent Tree
    local special_take_aim_attack_range = self:GetParent():FindAbilityByName("special_take_aim_attack_range_lua")
    if special_take_aim_attack_range and special_take_aim_attack_range:GetLevel() ~= 0 then
        bonus_attack_range = bonus_attack_range + special_take_aim_attack_range:GetSpecialValueFor("value")
    end
    -- Talent Tree
    local special_take_aim_agi_multiplier = self:GetParent():FindAbilityByName("special_take_aim_agi_multiplier_lua")
    if special_take_aim_agi_multiplier and special_take_aim_agi_multiplier:GetLevel() ~= 0 then
        agi_multiplier = agi_multiplier + special_take_aim_agi_multiplier:GetSpecialValueFor("value")
    end
    self:SetStackCount(bonus_attack_range + math.floor(self:GetParent():GetAgility() * agi_multiplier))
end