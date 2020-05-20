ursa_earthshock_lua = class({})
LinkLuaModifier("modifier_ursa_earthshock_lua", "lua_abilities/ursa_earthshock_lua/modifier_ursa_earthshock_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_earthshock_lua_buff", "lua_abilities/ursa_earthshock_lua/modifier_ursa_earthshock_lua_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------

function ursa_earthshock_lua:OnSpellStart()
    -- get references
    local caster = self:GetCaster()
    local hop_distance = self:GetSpecialValueFor("hop_distance")

    caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_generic_knockback_lua", -- modifier name
            {
                duration = 0.1,
                distance = hop_distance,
                height = 30,
                IsBackwards = false,
            } -- kv
    )

    caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_ursa_earthshock_lua_buff", -- modifier name
            {
                duration = 0.2,
            } -- kv
    )

    self:ActivateSpellMechanics()
end

function ursa_earthshock_lua:ActivateSpellMechanics()
    local caster = self:GetCaster()
    local slow_radius = self:GetSpecialValueFor("shock_radius")
    local slow_duration = self:GetDuration()
    local ability_damage = self:GetAbilityDamage() + self:GetCaster():GetAgility() * self:GetSpecialValueFor("agi_multiplier")
    -- get list of affected enemies
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetOrigin(),
            nil,
            slow_radius,
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            self:GetAbilityTargetFlags(),
            FIND_ANY_ORDER,
            false
    )

    -- Do for each affected enemies
    for _, enemy in pairs(enemies) do
        -- Apply damage
        local damage = {
            victim = enemy,
            attacker = caster,
            damage = ability_damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        }
        ApplyDamage(damage)

        -- Add slow modifier
        enemy:AddNewModifier(
                caster,
                self,
                "modifier_ursa_earthshock_lua",
                { duration = slow_duration }
        )
    end

    -- Play effects
    self:PlayEffects()
end

function ursa_earthshock_lua:PlayEffects()
    -- get resources
    local sound_cast = "Hero_Ursa.Earthshock"
    local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"

    -- get data
    local slow_radius = self:GetSpecialValueFor("shock_radius")

    -- play particles
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetCaster():GetOrigin())
    ParticleManager:SetParticleControlForward(effect_cast, 0, self:GetCaster():GetForwardVector())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(slow_radius / 2, slow_radius / 2, slow_radius / 2))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- play sounds
    EmitSoundOn(sound_cast, self:GetCaster())
end