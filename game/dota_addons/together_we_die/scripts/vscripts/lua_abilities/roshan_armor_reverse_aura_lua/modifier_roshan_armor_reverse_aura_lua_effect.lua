modifier_roshan_armor_reverse_aura_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_armor_reverse_aura_lua_effect:IsHidden()
    return false
end

function modifier_roshan_armor_reverse_aura_lua_effect:IsDebuff()
    return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber()
end

--------------------------------------------------------------------------------

function modifier_roshan_armor_reverse_aura_lua_effect:OnCreated(kv)
    self.aura_negative_armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
    self.aura_positive_armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
    self.missing_percent = self:GetAbility():GetSpecialValueFor("missing_percent")
end

--------------------------------------------------------------------------------

function modifier_roshan_armor_reverse_aura_lua_effect:OnRefresh(kv)
    self.aura_negative_armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
    self.aura_positive_armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
    self.missing_percent = self:GetAbility():GetSpecialValueFor("missing_percent")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_armor_reverse_aura_lua_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_roshan_armor_reverse_aura_lua_effect:GetModifierPhysicalArmorBonus()
    local missing_reverse = math.floor((100 - self:GetCaster():GetHealthPercent()) / self.missing_percent)

    if (self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber()) then
        return self.aura_negative_armor * missing_reverse
    end
    return self.aura_positive_armor * missing_reverse
end

--------------------------------------------------------------------------------

