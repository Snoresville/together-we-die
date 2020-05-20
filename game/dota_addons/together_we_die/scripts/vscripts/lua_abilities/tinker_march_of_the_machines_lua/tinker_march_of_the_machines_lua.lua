tinker_march_of_the_machines_lua = class({})
LinkLuaModifier("modifier_tinker_march_of_the_machines_lua_thinker", "lua_abilities/tinker_march_of_the_machines_lua/modifier_tinker_march_of_the_machines_lua_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_disarm_lua", "lua_abilities/generic/modifier_generic_disarm_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function tinker_march_of_the_machines_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- create thinker
    CreateModifierThinker(
            caster,
            self,
            "modifier_tinker_march_of_the_machines_lua_thinker",
            {},
            point,
            caster:GetTeamNumber(),
            false
    )

    -- Play effects
    self:PlayEffects()
end
--------------------------------------------------------------------------------
-- Projectile
function tinker_march_of_the_machines_lua:OnProjectileHit_ExtraData(target, location, extraData)
    if not target then
        return true
    end

    local int_multiplier = self:GetSpecialValueFor("int_multiplier")
    local disarm_duration = 0
    local stun_duration = 0
    -- Talent Tree
    local special_march_of_the_machines_int_multiplier_lua = self:GetCaster():FindAbilityByName("special_march_of_the_machines_int_multiplier_lua")
    if special_march_of_the_machines_int_multiplier_lua and special_march_of_the_machines_int_multiplier_lua:GetLevel() ~= 0 then
        int_multiplier = int_multiplier + special_march_of_the_machines_int_multiplier_lua:GetSpecialValueFor("value")
    end
    local splash_damage = self:GetAbilityDamage() + (self:GetCaster():GetIntellect() * int_multiplier)
    -- Talent Tree
    local special_march_of_the_machines_disarm_duration_lua = self:GetCaster():FindAbilityByName("special_march_of_the_machines_disarm_duration_lua")
    if special_march_of_the_machines_disarm_duration_lua and special_march_of_the_machines_disarm_duration_lua:GetLevel() ~= 0 then
        disarm_duration = special_march_of_the_machines_disarm_duration_lua:GetSpecialValueFor("value")
    end
    -- Talent Tree
    local special_march_of_the_machines_stun_duration_lua = self:GetCaster():FindAbilityByName("special_march_of_the_machines_stun_duration_lua")
    if special_march_of_the_machines_stun_duration_lua and special_march_of_the_machines_stun_duration_lua:GetLevel() ~= 0 then
        stun_duration = special_march_of_the_machines_stun_duration_lua:GetSpecialValueFor("value")
    end

    -- find units in radius
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            location, -- point, center point
            nil, -- handle, cacheUnit. (not known)
            extraData.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- explode
    local damageTable = {
        -- victim = target,
        attacker = self:GetCaster(),
        damage = splash_damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    for _, enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)

        if disarm_duration ~= 0 then
            enemy:AddNewModifier(
                    self:GetCaster(), -- player source
                    self, -- ability source
                    "modifier_generic_disarm_lua", -- modifier name
                    { duration = disarm_duration } -- kv
            )
        end

        if stun_duration ~= 0 then
            enemy:AddNewModifier(
                    self:GetCaster(), -- player source
                    self, -- ability source
                    "modifier_generic_stunned_lua", -- modifier name
                    { duration = stun_duration } -- kv
            )
        end
    end

    return true
end

--------------------------------------------------------------------------------
function tinker_march_of_the_machines_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_tinker/tinker_motm.vpcf"
    local sound_cast = "Hero_Tinker.March_of_the_Machines.Cast"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetCaster(),
            PATTACH_POINT_FOLLOW,
            "attach_attack1",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOnLocationForAllies(self:GetCaster():GetOrigin(), sound_cast, self:GetCaster())
end