--------------------------------------------------------------------------------
modifier_riki_smoke_screen_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_smoke_screen_lua:IsHidden()
    return false
end

function modifier_riki_smoke_screen_lua:IsDebuff()
    return true
end

function modifier_riki_smoke_screen_lua:IsStunDebuff()
    return false
end

function modifier_riki_smoke_screen_lua:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_smoke_screen_lua:OnCreated(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")

    if not IsServer() then
        return
    end
    -- Play effects
    self:PlayEffects()
end

function modifier_riki_smoke_screen_lua:OnRefresh(kv)
end

function modifier_riki_smoke_screen_lua:OnRemoved()
end

function modifier_riki_smoke_screen_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_riki_smoke_screen_lua:IsAura()
    return true
end

function modifier_riki_smoke_screen_lua:GetModifierAura()
    return "modifier_riki_smoke_screen_lua_debuff"
end

function modifier_riki_smoke_screen_lua:GetAuraRadius()
    return self.radius
end

function modifier_riki_smoke_screen_lua:GetAuraDuration()
    return 0.5
end

function modifier_riki_smoke_screen_lua:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_riki_smoke_screen_lua:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

function modifier_riki_smoke_screen_lua:GetAuraSearchFlags()
    return 0
end

function modifier_riki_smoke_screen_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"
    local sound_cast = "Hero_Riki.Smoke_Screen"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster())
end