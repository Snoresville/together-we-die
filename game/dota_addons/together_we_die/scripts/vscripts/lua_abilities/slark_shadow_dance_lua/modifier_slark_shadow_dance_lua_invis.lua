modifier_slark_shadow_dance_lua_invis = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua_invis:IsHidden()
    return false
end

function modifier_slark_shadow_dance_lua_invis:IsDebuff()
    return false
end

function modifier_slark_shadow_dance_lua_invis:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua_invis:OnCreated(kv)
    if IsServer() then
        if self:GetParent() == self:GetCaster() then
            self:PlayEffects()
        end
    end
end

function modifier_slark_shadow_dance_lua_invis:OnRefresh(kv)
end

function modifier_slark_shadow_dance_lua_invis:OnDestroy(kv)
    if IsServer() then
        self:StopEffects()
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_shadow_dance_lua_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }

    return funcs
end

function modifier_slark_shadow_dance_lua_invis:GetModifierInvisibilityLevel()
    return 2
end

function modifier_slark_shadow_dance_lua_invis:GetActivityTranslationModifiers()
    return "shadow_dance"
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_slark_shadow_dance_lua_invis:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_shadow_dance_lua_invis:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
    local sound_cast = "Hero_Slark.ShadowDance"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeL", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeR", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(effect_cast, false, false, -1, false, false)

    EmitSoundOn(sound_cast, self:GetParent())
end

function modifier_slark_shadow_dance_lua_invis:StopEffects()
    local sound_cast = "Hero_Slark.ShadowDance"
    StopSoundOn(sound_cast, self:GetParent())
end

function modifier_slark_shadow_dance_lua_invis:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_slark_shadow_dance_lua_invis:StatusEffectPriority()
    return 10
end