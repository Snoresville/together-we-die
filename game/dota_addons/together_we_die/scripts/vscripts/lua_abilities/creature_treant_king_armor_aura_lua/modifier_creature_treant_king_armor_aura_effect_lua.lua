modifier_creature_treant_king_armor_aura_effect_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_treant_king_armor_aura_effect_lua:IsHidden()
    return false
end

function modifier_creature_treant_king_armor_aura_effect_lua:IsDebuff()
    return false
end

function modifier_creature_treant_king_armor_aura_effect_lua:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_treant_king_armor_aura_effect_lua:OnCreated()
    -- references
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_creature_treant_king_armor_aura_effect_lua:OnRefresh()
    -- references
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_treant_king_armor_aura_effect_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_creature_treant_king_armor_aura_effect_lua:GetModifierConstantHealthRegen()
    return self.regen
end

function modifier_creature_treant_king_armor_aura_effect_lua:GetModifierPhysicalArmorBonus()
    return self.armor
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_treant_king_armor_aura_effect_lua:GetEffectName()
    return "particles/units/heroes/hero_treant/treant_livingarmor.vpcf"
end

function modifier_creature_treant_king_armor_aura_effect_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end