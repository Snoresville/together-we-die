modifier_invoker_quas_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_quas_lua:IsHidden()
    return false
end

function modifier_invoker_quas_lua:IsDebuff()
    return false
end

function modifier_invoker_quas_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_invoker_quas_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_quas_lua:OnCreated(kv)
    -- references
    self.regen = self:GetAbility():GetSpecialValueFor("health_regen_per_instance") -- special value
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.hp_int_multiplier = self:GetAbility():GetSpecialValueFor("hp_int_multiplier")
    if not IsServer() then
        return
    end
    local special_quas_multiply_stats_lua = self:GetParent():FindAbilityByName("special_quas_multiply_stats_lua")
    if special_quas_multiply_stats_lua and special_quas_multiply_stats_lua:GetLevel() ~= 0 then
        self:SetStackCount(special_quas_multiply_stats_lua:GetSpecialValueFor("value"))
    else
        self:SetStackCount(1)
    end
end

function modifier_invoker_quas_lua:OnRefresh(kv)
    -- references
    self:OnCreated(kv)
end

function modifier_invoker_quas_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_quas_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_BONUS
    }

    return funcs
end
function modifier_invoker_quas_lua:GetModifierConstantHealthRegen()
    return self.regen + math.floor(self:GetParent():GetIntellect() * self.int_multiplier) * self:GetStackCount()
end

function modifier_invoker_quas_lua:GetModifierHealthBonus()
    if self:GetCaster():GetModifierStackCount("modifier_invoker_quas_hp_lua", self:GetCaster()) == 1 then
        return math.floor(self:GetParent():GetIntellect() * self.hp_int_multiplier) * self:GetStackCount()
    end
    return 0
end