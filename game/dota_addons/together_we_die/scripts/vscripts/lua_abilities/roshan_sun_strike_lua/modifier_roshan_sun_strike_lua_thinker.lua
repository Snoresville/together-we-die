modifier_roshan_sun_strike_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_sun_strike_lua_thinker:IsHidden()
    return true
end

function modifier_roshan_sun_strike_lua_thinker:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_sun_strike_lua_thinker:OnCreated(kv)
    if IsServer() then
        -- references
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
        self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
        self.primary_stat_multiplier = self:GetAbility():GetSpecialValueFor("primary_stat_multiplier")

        -- Play effects
        self:PlayEffects1()
    end
end

function modifier_roshan_sun_strike_lua_thinker:OnDestroy(kv)
    if IsServer() then
        -- Damage enemies
        local damageTable = {
            -- victim = target,
            attacker = self:GetCaster(),
            -- damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(), -- int, your team number
                self:GetParent():GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
                self:GetAbility():GetAbilityTargetType(), -- int, type filter
                self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )

        for _, enemy in pairs(enemies) do
            damageTable.victim = enemy
            if enemy:IsHero() then
                damageTable.damage = self.damage / #enemies + (enemy:GetPrimaryStatValue() * self.primary_stat_multiplier)
                enemy:ReduceMana(damageTable.damage)
            else
                damageTable.damage = self.damage / #enemies
            end

            ApplyDamage(damageTable)
        end

        -- Play effects
        self:PlayEffects2()

        -- remove thinker
        UTIL_Remove(self:GetParent())
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_roshan_sun_strike_lua_thinker:PlayEffects1()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
    local sound_cast = "Hero_Invoker.SunStrike.Charge"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster())
end

function modifier_roshan_sun_strike_lua_thinker:PlayEffects2()
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