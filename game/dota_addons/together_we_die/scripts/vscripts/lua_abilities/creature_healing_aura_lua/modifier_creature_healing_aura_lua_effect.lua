modifier_creature_healing_aura_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_healing_aura_lua_effect:IsHidden()
    return false
end

function modifier_creature_healing_aura_lua_effect:IsDebuff()
    return false
end

function modifier_creature_healing_aura_lua_effect:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_healing_aura_lua_effect:OnCreated(kv)
    -- references
    self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_creature_healing_aura_lua_effect:OnRefresh(kv)
    -- references
    self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_healing_aura_lua_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_creature_healing_aura_lua_effect:GetModifierConstantHealthRegen()
    return self.hp_regen
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_healing_aura_lua_effect:GetEffectName()
    return "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_heal.vpcf"
end

function modifier_creature_healing_aura_lua_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end