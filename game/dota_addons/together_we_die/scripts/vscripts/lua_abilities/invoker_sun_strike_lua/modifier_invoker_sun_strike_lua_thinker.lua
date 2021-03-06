modifier_invoker_sun_strike_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_sun_strike_lua_thinker:IsHidden()
    return true
end

function modifier_invoker_sun_strike_lua_thinker:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_sun_strike_lua_thinker:OnCreated(kv)
    if IsServer() then
        -- references
        self.int_multiplier = self:GetAbility():GetOrbSpecialValueFor("int_multiplier", "e")
        self.damage = self:GetAbility():GetOrbSpecialValueFor("damage", "e") + self:GetCaster():GetIntellect() * self.int_multiplier
        self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
        self.visible = kv.visible

        -- Play effects
        self:PlayEffects1()
    end
end

function modifier_invoker_sun_strike_lua_thinker:OnDestroy(kv)
    if IsServer() then
        local caster = self:GetCaster()
        -- Damage enemies
        local damageTable = {
            -- victim = target,
            attacker = caster,
            -- damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        local enemies = FindUnitsInRadius(
                caster:GetTeamNumber(), -- int, your team number
                self:GetParent():GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
                self:GetAbility():GetAbilityTargetType(), -- int, type filter
                self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )

        -- Talent tree
        local special_sun_strike_stun_lua = caster:FindAbilityByName("special_sun_strike_stun_lua")
        local stun_duration = 0
        if (special_sun_strike_stun_lua and special_sun_strike_stun_lua:GetLevel() ~= 0) then
            stun_duration = special_sun_strike_stun_lua:GetSpecialValueFor("value")
        end

        for _, enemy in pairs(enemies) do
            damageTable.victim = enemy
            damageTable.damage = self.damage / #enemies
            ApplyDamage(damageTable)

            if stun_duration ~= 0 then
                -- stun
                enemy:AddNewModifier(
                        caster, -- player source
                        self:GetAbility(), -- ability source
                        "modifier_generic_stunned_lua", -- modifier name
                        {
                            duration = stun_duration,
                        }
                )
            end
        end

        -- Play effects
        self:PlayEffects2()

        -- remove thinker
        UTIL_Remove(self:GetParent())
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_invoker_sun_strike_lua_thinker:PlayEffects1()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
    local sound_cast = "Hero_Invoker.SunStrike.Charge"

    local effect_cast = ParticleManager:CreateParticleForTeam(particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber())
    if self.visible then
        effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, self:GetCaster())
        -- Create Sound
        EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster())
    else
        -- Create Sound
        EmitSoundOnLocationForAllies(self:GetParent():GetOrigin(), sound_cast, self:GetCaster())
    end
    -- Create Particle
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)
end

function modifier_invoker_sun_strike_lua_thinker:PlayEffects2()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
    local sound_cast = "Hero_Invoker.SunStrike.Ignite"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster())
end