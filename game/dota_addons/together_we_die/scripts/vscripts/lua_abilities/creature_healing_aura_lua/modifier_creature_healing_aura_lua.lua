modifier_creature_healing_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_healing_aura_lua:IsHidden()
    return true
end

function modifier_creature_healing_aura_lua:IsDebuff()
    return false
end

function modifier_creature_healing_aura_lua:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_creature_healing_aura_lua:IsAura()
    return (not self:GetCaster():PassivesDisabled())
end
function modifier_creature_healing_aura_lua:GetModifierAura()
    return "modifier_creature_healing_aura_lua_effect"
end

function modifier_creature_healing_aura_lua:GetAuraRadius()
    return self.radius
end

function modifier_creature_healing_aura_lua:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_creature_healing_aura_lua:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_healing_aura_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")

    if not IsServer() then
        return
    end
    self:PlayEffects()
end

function modifier_creature_healing_aura_lua:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_healing_aura_lua:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 1, 1))

    -- buff particle
    self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
    )

    local particle_cast2 = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_aura.vpcf"
    local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    -- buff particle
    self:AddParticle(
            effect_cast2,
            false,
            false,
            -1,
            false,
            false
    )
end