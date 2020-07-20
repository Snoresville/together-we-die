modifier_creature_slark_essence_shift_lua_stack = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_essence_shift_lua_stack:IsHidden()
    return false
end

function modifier_creature_slark_essence_shift_lua_stack:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_essence_shift_lua_stack:OnCreated(kv)
    self.armor_gain = self:GetAbility():GetSpecialValueFor("armor_gain")
    self.as_gain = self:GetAbility():GetSpecialValueFor("as_gain")
    self.max_as_gain = self:GetAbility():GetSpecialValueFor("max_as_gain")
    -- Add stack
    self:SetStackCount(1)
end

function modifier_creature_slark_essence_shift_lua_stack:OnRefresh(kv)
    self.armor_gain = self:GetAbility():GetSpecialValueFor("armor_gain")
    self.as_gain = self:GetAbility():GetSpecialValueFor("as_gain")
    self.max_as_gain = self:GetAbility():GetSpecialValueFor("max_as_gain")
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_slark_essence_shift_lua_stack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_creature_slark_essence_shift_lua_stack:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * self.armor_gain
end

function modifier_creature_slark_essence_shift_lua_stack:GetModifierAttackSpeedBonus_Constant()
    return math.min(self:GetStackCount() * self.as_gain, self.max_as_gain)
end