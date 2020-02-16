--------------------------------------------------------------------------------
modifier_abaddon_aphotic_shield_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_aphotic_shield_lua:IsHidden()
    return false
end

function modifier_abaddon_aphotic_shield_lua:IsDebuff()
    return false
end

function modifier_abaddon_aphotic_shield_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_aphotic_shield_lua:OnCreated(kv)
    self.max_absorption = self:GetAbility():GetSpecialValueFor("damage_absorb") + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("str_multiplier")
    self.burst_radius = self:GetAbility():GetSpecialValueFor("burst_radius")
    self.current_absorbed_damage = 0

    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self:PlayEffect1()
end

function modifier_abaddon_aphotic_shield_lua:OnRefresh(kv)
    self.max_absorption = self:GetAbility():GetSpecialValueFor("damage_absorb") + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("str_multiplier")
    self.burst_radius = self:GetAbility():GetSpecialValueFor("burst_radius")
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end

function modifier_abaddon_aphotic_shield_lua:OnRemoved()
end

function modifier_abaddon_aphotic_shield_lua:OnDestroy()
    if not IsServer() then
        return
    end
    -- Shield Explosion
    local caster = self:GetCaster()
    local damageTable = {
        attacker = caster,
        damage = self.max_absorption * self:GetStackCount(),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            self:GetParent():GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.burst_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )
    for _, enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
    end

    -- Shield explosion effect
    self:PlayEffect2()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_aphotic_shield_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_abaddon_aphotic_shield_lua:GetModifierIncomingDamage_Percentage(params)
    if IsServer() then
        -- check if borrow time buff is active
        if self:GetParent():HasModifier("modifier_abaddon_borrow_time_lua_buff") then
            return
        end

        local reduction = 100
        local damageTaken = params.original_damage

        self.current_absorbed_damage = self.current_absorbed_damage + damageTaken

        if self.current_absorbed_damage > (self.max_absorption * self:GetStackCount()) then
            -- blow up the shield
            self:Destroy()
        end

        return -reduction
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_abaddon_aphotic_shield_lua:PlayEffect1()
    self.shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    local shield_size = self:GetParent():GetHullRadius() + 75
    ParticleManager:SetParticleControl(self.shield_particle, 1, Vector(shield_size, 0, shield_size))
    ParticleManager:SetParticleControl(self.shield_particle, 2, Vector(shield_size, 0, shield_size))
    ParticleManager:SetParticleControl(self.shield_particle, 4, Vector(shield_size, 0, shield_size))
    ParticleManager:SetParticleControl(self.shield_particle, 5, Vector(shield_size, 0, 0))

    ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

    -- Create Sound
    local sound_loop = "Hero_Abaddon.AphoticShield.Loop"
    EmitSoundOn(sound_loop, self:GetParent())
end

function modifier_abaddon_aphotic_shield_lua:PlayEffect2()
    -- Remove shield particle
    ParticleManager:DestroyParticle(self.shield_particle, false)
    ParticleManager:ReleaseParticleIndex(self.shield_particle)

    -- Stop Loop Sound
    local sound_loop = "Hero_Abaddon.AphoticShield.Loop"
    StopSoundOn(sound_loop, self:GetParent())

    -- effects
    local sound_cast = "Hero_Abaddon.AphoticShield.Destroy"
    EmitSoundOn(sound_cast, self:GetParent())

    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.burst_radius, self.burst_radius, self.burst_radius))
    ParticleManager:ReleaseParticleIndex(effect_cast)
end
