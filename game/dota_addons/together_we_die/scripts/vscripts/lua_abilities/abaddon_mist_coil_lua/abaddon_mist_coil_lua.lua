abaddon_mist_coil_lua = class({})

--------------------------------------------------------------------------------
-- AOE Radius
function abaddon_mist_coil_lua:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function abaddon_mist_coil_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local str_multiplier = self:GetSpecialValueFor("str_multiplier")
    local self_damage = self:GetSpecialValueFor("self_damage") + caster:GetStrength() * str_multiplier
    local radius = self:GetSpecialValueFor( "radius" )

    local projectile_speed = self:GetSpecialValueFor("missile_speed")
    local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

    -- logic
    local info = {
        Target = target,
        Source = caster,
        Ability = self,

        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bDodgeable = true, -- Optional
    }
    -- Find Units in Radius
    local targets = FindUnitsInRadius(
            caster:GetTeamNumber(),	-- int, your team number
            target:GetOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
    )
    for _,coilTarget in pairs(targets) do
        if coilTarget ~= caster then
            -- will not coil the caster
            info.Target = coilTarget
            ProjectileManager:CreateTrackingProjectile(info)
        end
    end

    -- self damage
    local damageTable = {
        victim = caster,
        attacker = caster,
        damage = self_damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    -- Play effects
    self:PlayEffects()
end
--------------------------------------------------------------------------------
-- Projectile
function abaddon_mist_coil_lua:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local str_multiplier = self:GetSpecialValueFor("str_multiplier")

    -- check if enemy or ally
    local ally = false
    if target:GetTeamNumber() == caster:GetTeamNumber() then
        ally = true
    end

    if ally then
        -- ally logic
        local heal_amount = self:GetSpecialValueFor("heal_amount") + caster:GetStrength() * str_multiplier
        target:Heal(heal_amount, self:GetCaster())
    else
        -- enemy logic
        -- cancel if linken
        if target:IsInvulnerable() or target:TriggerSpellAbsorb(self) then
            return
        end

        local target_damage = self:GetSpecialValueFor("target_damage") + caster:GetStrength() * str_multiplier
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = target_damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self, --Optional.
        }
        ApplyDamage(damageTable)
    end

    -- Play effects
    local sound_target = "Hero_Abaddon.DeathCoil.Target"
    EmitSoundOn(sound_target, target)
end

--------------------------------------------------------------------------------
function abaddon_mist_coil_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf"
    local sound_cast = "Hero_Abaddon.DeathCoil.Cast"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetCaster())
end