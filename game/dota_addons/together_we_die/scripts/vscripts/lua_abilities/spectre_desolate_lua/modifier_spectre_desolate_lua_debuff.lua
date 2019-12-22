modifier_spectre_desolate_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_desolate_lua_debuff:IsHidden()
    return false
end

function modifier_spectre_desolate_lua_debuff:IsDebuff()
    return true
end

function modifier_spectre_desolate_lua_debuff:IsPurgable()
    return false
end

function modifier_spectre_desolate_lua_debuff:IsPurgeException()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spectre_desolate_lua_debuff:OnCreated(kv)
    -- references
    self.vision = self:GetAbility():GetSpecialValueFor("vision")
    self.armor_loss = self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self:SetStackCount(1)
end

function modifier_spectre_desolate_lua_debuff:OnRefresh(kv)
    -- references
    self.vision = self:GetAbility():GetSpecialValueFor("vision")
    self.armor_loss = self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self:IncrementStackCount()
end

function modifier_spectre_desolate_lua_debuff:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spectre_desolate_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
    }

    return funcs
end

function modifier_spectre_desolate_lua_debuff:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * -self.armor_loss
end

function modifier_spectre_desolate_lua_debuff:GetFixedDayVision()
    return self.vision
end

function modifier_spectre_desolate_lua_debuff:GetFixedNightVision()
    return self.vision
end