modifier_creature_slark_essence_shift_lua_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_essence_shift_lua_debuff:IsHidden()
    return false
end

function modifier_creature_slark_essence_shift_lua_debuff:IsDebuff()
    return true
end

function modifier_creature_slark_essence_shift_lua_debuff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_essence_shift_lua_debuff:OnCreated(kv)
    -- references
    self.armor_loss = self:GetAbility():GetSpecialValueFor("armor_loss")
    self.stat_loss = self:GetAbility():GetSpecialValueFor("stat_loss")
    self:SetStackCount(1)
end

function modifier_creature_slark_essence_shift_lua_debuff:OnRefresh(kv)
    -- references
    self.armor_loss = self:GetAbility():GetSpecialValueFor("armor_loss")
    self.stat_loss = self:GetAbility():GetSpecialValueFor("stat_loss")
end

function modifier_creature_slark_essence_shift_lua_debuff:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_slark_essence_shift_lua_debuff:DeclareFunctions()
    if self:GetParent():IsRealHero() then
        local hero_funcs = {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        }

        return hero_funcs
    end

    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_creature_slark_essence_shift_lua_debuff:GetModifierPhysicalArmorBonus()
    return math.floor(self:GetStackCount() * -self.armor_loss)
end

function modifier_creature_slark_essence_shift_lua_debuff:GetModifierBonusStats_Strength()
    return math.floor(self:GetStackCount() * -self.stat_loss)
end

function modifier_creature_slark_essence_shift_lua_debuff:GetModifierBonusStats_Agility()
    return math.floor(self:GetStackCount() * -self.stat_loss)
end

function modifier_creature_slark_essence_shift_lua_debuff:GetModifierBonusStats_Intellect()
	return math.floor(self:GetStackCount() * -self.stat_loss)
end