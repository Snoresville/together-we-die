modifier_intelligence_magic_scale_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_intelligence_magic_scale_lua:IsHidden()
    return true
end

function modifier_intelligence_magic_scale_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_intelligence_magic_scale_lua:OnCreated(kv)
    -- references
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.int_mana_reduction = self:GetAbility():GetSpecialValueFor("int_mana_reduction")
    self.int_hp_reduction = self:GetAbility():GetSpecialValueFor("int_hp_reduction")
    self.cooldown_increment = self:GetAbility():GetSpecialValueFor("cooldown_increment")

    self.max_reduction = 99
end

function modifier_intelligence_magic_scale_lua:OnRefresh(kv)
    -- references
    self:OnCreated(kv)
end

function modifier_intelligence_magic_scale_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_intelligence_magic_scale_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }

    return funcs
end

function modifier_intelligence_magic_scale_lua:GetModifierSpellAmplify_Percentage(params)
    if not self:GetParent():PassivesDisabled() then
        return math.floor(self:GetParent():GetIntellect() * self.int_multiplier)
    end

    return 0
end

-- Increases cooldown
function modifier_intelligence_magic_scale_lua:GetModifierPercentageCooldown()
    return -self.cooldown_increment
end

-- Decreases mana
function modifier_intelligence_magic_scale_lua:GetModifierManaBonus()
    return -math.floor(self:GetParent():GetIntellect() * self.int_mana_reduction)
end

-- Decreases strength
function modifier_intelligence_magic_scale_lua:GetModifierExtraHealthPercentage()
    local reduction = math.min(math.floor(self:GetParent():GetIntellect() * self.int_hp_reduction), self.max_reduction)

    return -reduction
end