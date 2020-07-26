modifier_creature_slark_shadow_dance_lua_invis = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_shadow_dance_lua_invis:IsHidden()
    return false
end

function modifier_creature_slark_shadow_dance_lua_invis:IsDebuff()
    return false
end

function modifier_creature_slark_shadow_dance_lua_invis:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_shadow_dance_lua_invis:OnCreated(kv)
    self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen_pct") -- special value

    if IsServer() then
        -- Start interval
        local interval = 1
        self:OnIntervalThink()
        self:StartIntervalThink( interval )

        if self:GetParent() == self:GetCaster() then
            self:PlayEffects()
        end
    end
end

function modifier_creature_slark_shadow_dance_lua_invis:OnRefresh(kv)
end

function modifier_creature_slark_shadow_dance_lua_invis:OnDestroy(kv)
    if IsServer() then
        self:StopEffects()
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_slark_shadow_dance_lua_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }

    return funcs
end

function modifier_creature_slark_shadow_dance_lua_invis:GetModifierInvisibilityLevel()
    return 2
end

function modifier_creature_slark_shadow_dance_lua_invis:GetActivityTranslationModifiers()
    return "shadow_dance"
end

function modifier_creature_slark_shadow_dance_lua_invis:GetModifierHealthRegenPercentage()
    return self.bonus_regen
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_creature_slark_shadow_dance_lua_invis:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_slark_shadow_dance_lua_invis:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
    local sound_cast = "Hero_Slark.ShadowDance"
    local caster = self:GetParent()

    EmitSoundOn(sound_cast, self:GetParent())

    -- create modifier thinker
    self.thinker = CreateModifierThinker(
            caster,
            self:GetAbility(),
            "modifier_creature_slark_shadow_dance_lua_thinker",
            { },
            caster:GetAbsOrigin(),
            caster:GetTeamNumber(),
            false
    )

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(effect_cast, 1, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 3, caster, PATTACH_POINT_FOLLOW, "attach_eyeL", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 4, caster, PATTACH_POINT_FOLLOW, "attach_eyeR", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(effect_cast, false, false, -1, false, false)

    EmitSoundOn(sound_cast, caster)
end

--------------------------------------------------------------------------------
-- OnThink
function modifier_creature_slark_shadow_dance_lua_invis:OnIntervalThink()
    if self:GetParent():IsAlive() then
        local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                self:GetParent():GetOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
                FIND_CLOSEST,	-- int, order filter
                false	-- bool, can grow cache
        )

        for _,enemy in pairs(enemies) do
            self:GetParent():MoveToTargetToAttack( enemy )
            break
        end
    end
end

function modifier_creature_slark_shadow_dance_lua_invis:StopEffects()
    local sound_cast = "Hero_Slark.ShadowDance"
    StopSoundOn(sound_cast, self:GetParent())

    if self.thinker ~= nil then
        self.thinker:ForceKill(false)
    end
end

function modifier_creature_slark_shadow_dance_lua_invis:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_creature_slark_shadow_dance_lua_invis:StatusEffectPriority()
    return 10
end