modifier_invoker_wex_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_wex_lua:IsHidden()
    return false
end

function modifier_invoker_wex_lua:IsDebuff()
    return false
end

function modifier_invoker_wex_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_invoker_wex_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_wex_lua:OnCreated(kv)
    -- references
    self.as_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_per_instance") -- special value
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("move_speed_per_instance") -- special value
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.cdr_int_multiplier = self:GetAbility():GetSpecialValueFor("cdr_int_multiplier")
    self.max_cdr = self:GetAbility():GetSpecialValueFor("max_cdr")
end

function modifier_invoker_wex_lua:OnRefresh(kv)
    -- references
    self:OnCreated(kv)
end

function modifier_invoker_wex_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_wex_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }

    return funcs
end

function modifier_invoker_wex_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus + self:GetParent():GetIntellect() * self.int_multiplier
end
function modifier_invoker_wex_lua:GetModifierAttackSpeedBonus_Constant()
    return self.as_bonus + self:GetParent():GetIntellect() * self.int_multiplier
end

function modifier_invoker_wex_lua:GetModifierPercentageCooldown()
    if self:GetCaster():GetModifierStackCount("modifier_invoker_wex_cdr_lua", self:GetCaster()) == 1 then
        return math.min(math.floor(self:GetParent():GetIntellect() * self.cdr_int_multiplier), self.max_cdr)
    end

    return 0
end
