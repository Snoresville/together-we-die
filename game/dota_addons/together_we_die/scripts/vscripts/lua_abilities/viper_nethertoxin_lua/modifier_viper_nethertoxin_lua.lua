-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_viper_nethertoxin_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_viper_nethertoxin_lua:IsHidden()
    return true
end

function modifier_viper_nethertoxin_lua:IsDebuff()
    return true
end

function modifier_viper_nethertoxin_lua:IsStunDebuff()
    return false
end

function modifier_viper_nethertoxin_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_viper_nethertoxin_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")

    if not IsServer() then
        return
    end

    self:PlayEffects()
end

function modifier_viper_nethertoxin_lua:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_viper_nethertoxin_lua:OnRemoved()
end

function modifier_viper_nethertoxin_lua:OnDestroy()
    if not IsServer() then
        return
    end
    UTIL_Remove(self:GetParent())
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_viper_nethertoxin_lua:IsAura()
    return true
end

function modifier_viper_nethertoxin_lua:GetModifierAura()
    return "modifier_viper_nethertoxin_lua_debuff"
end

function modifier_viper_nethertoxin_lua:GetAuraRadius()
    return self.radius
end

function modifier_viper_nethertoxin_lua:GetAuraDuration()
    return 0.5
end

function modifier_viper_nethertoxin_lua:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_viper_nethertoxin_lua:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_viper_nethertoxin_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_viper/viper_nethertoxin.vpcf"
    local sound_cast = "Hero_Viper.NetherToxin"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 1, 1))
    -- ParticleManager:ReleaseParticleIndex( effect_cast )

    -- buff particle
    self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
    )

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetParent())
end