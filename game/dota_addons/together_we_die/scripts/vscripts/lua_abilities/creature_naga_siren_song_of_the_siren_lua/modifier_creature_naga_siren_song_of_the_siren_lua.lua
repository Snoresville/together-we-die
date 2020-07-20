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
modifier_creature_naga_siren_song_of_the_siren_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_naga_siren_song_of_the_siren_lua:IsHidden()
    return false
end

function modifier_creature_naga_siren_song_of_the_siren_lua:IsDebuff()
    return false
end

function modifier_creature_naga_siren_song_of_the_siren_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_naga_siren_song_of_the_siren_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.regen_rate = self:GetAbility():GetSpecialValueFor("regen_rate")

    if not IsServer() then
        return
    end

    -- play effects
    self:PlayEffects()
end

function modifier_creature_naga_siren_song_of_the_siren_lua:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.regen_rate = self:GetAbility():GetSpecialValueFor("regen_rate")
end

function modifier_creature_naga_siren_song_of_the_siren_lua:OnRemoved()
end

function modifier_creature_naga_siren_song_of_the_siren_lua:OnDestroy()
    if not IsServer() then
        return
    end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_creature_naga_siren_song_of_the_siren_lua:End()
    -- play effects
    local sound_cast = "Hero_NagaSiren.SongOfTheSiren"
    local sound_stop = "Hero_NagaSiren.SongOfTheSiren.Cancel"
    StopSoundOn(sound_cast, self:GetCaster())
    EmitSoundOn(sound_stop, self:GetCaster())

    -- destroy
    self:Destroy()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_creature_naga_siren_song_of_the_siren_lua:IsAura()
    return true
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetModifierAura()
    return "modifier_creature_naga_siren_song_of_the_siren_lua_debuff"
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetAuraRadius()
    return self.radius
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetAuraDuration()
    return 0.4
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_naga_siren_song_of_the_siren_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }

    return funcs
end

function modifier_creature_naga_siren_song_of_the_siren_lua:GetModifierHealthRegenPercentage()
    return self.regen_rate
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_naga_siren_song_of_the_siren_lua:PlayEffects()
    -- Get Resources
    local particle_cast1 = "particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf"
    local particle_cast2 = "particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf"
    local sound_cast = "Hero_NagaSiren.SongOfTheSiren"

    -- Get Data
    local caster = self:GetCaster()

    -- Create Particle 1
    local effect_cast = ParticleManager:CreateParticle(particle_cast1, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- create particle 2
    effect_cast = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )

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
    EmitSoundOn(sound_cast, caster)
end