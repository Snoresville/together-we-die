creature_crystal_maiden_crystal_nova_lua = class({})
LinkLuaModifier("modifier_creature_crystal_maiden_crystal_nova_lua", "lua_abilities/creature_crystal_maiden_crystal_nova_lua/modifier_creature_crystal_maiden_crystal_nova_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- AOE Radius
function creature_crystal_maiden_crystal_nova_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Ability Start
function creature_crystal_maiden_crystal_nova_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local damage = self:GetSpecialValueFor("nova_damage")
    local radius = self:GetSpecialValueFor("radius")
    local debuffDuration = self:GetSpecialValueFor("duration")

    local vision_radius = 900
    local vision_duration = 6

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            point, -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- Precache damage
    local damageTable = {
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }

    for _, enemy in pairs(enemies) do
        -- Apply damage
        damageTable.victim = enemy
        ApplyDamage(damageTable)

        -- Add modifier
        enemy:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_creature_crystal_maiden_crystal_nova_lua", -- modifier name
                { duration = debuffDuration } -- kv
        )
    end

    AddFOWViewer(self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true)

    self:PlayEffects(point, radius, debuffDuration)
end

--------------------------------------------------------------------------------
function creature_crystal_maiden_crystal_nova_lua:PlayEffects(point, radius, duration)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local sound_cast = "Hero_Crystal.CrystalNova"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, point)
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, duration, radius))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOnLocationWithCaster(point, sound_cast, self:GetCaster())
end