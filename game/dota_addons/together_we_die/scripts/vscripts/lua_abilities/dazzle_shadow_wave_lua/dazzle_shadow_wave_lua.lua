dazzle_shadow_wave_lua = class({})
LinkLuaModifier("modifier_dazzle_shadow_wave_lua", "lua_abilities/dazzle_shadow_wave_lua/modifier_dazzle_shadow_wave_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_poison_touch_lua", "lua_abilities/dazzle_poison_touch_lua/modifier_dazzle_poison_touch_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_shallow_grave_lua", "lua_abilities/dazzle_shallow_grave_lua/modifier_dazzle_shallow_grave_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function dazzle_shadow_wave_lua:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- references
    self.radius = self:GetSpecialValueFor("damage_radius")
    self.bounce_radius = self:GetSpecialValueFor("bounce_radius")
    local jumps = self:GetSpecialValueFor("max_targets")
    local int_multiplier = self:GetSpecialValueFor("int_multiplier")
    -- Talent tree
    local special_shadow_wave_int_multiplier_lua = caster:FindAbilityByName("special_shadow_wave_int_multiplier_lua")
    if (special_shadow_wave_int_multiplier_lua and special_shadow_wave_int_multiplier_lua:GetLevel() ~= 0) then
        int_multiplier = int_multiplier + special_shadow_wave_int_multiplier_lua:GetSpecialValueFor("value")
    end
    self.damage = self:GetSpecialValueFor("damage") + (caster:GetIntellect() * int_multiplier)
    -- Talent tree (Shadow wave applies shallow grave on friendly targeted units)
    self.special_shadow_wave_shallow_grave_lua = 0
    local special_shadow_wave_shallow_grave_lua = caster:FindAbilityByName("special_shadow_wave_shallow_grave_lua")
    self.shallow_grave = caster:FindAbilityByName("dazzle_shallow_grave_lua")
    if (special_shadow_wave_shallow_grave_lua and special_shadow_wave_shallow_grave_lua:GetLevel() ~= 0 and self.shallow_grave and self.shallow_grave:GetLevel() > 0) then
        self.special_shadow_wave_shallow_grave_lua = special_shadow_wave_shallow_grave_lua:GetSpecialValueFor("value")
    end
    -- Talent tree (Shadow wave applies poison touch on nearby enemy units)
    self.special_shadow_wave_poison_touch_lua = 0
    local special_shadow_wave_poison_touch_lua = caster:FindAbilityByName("special_shadow_wave_poison_touch_lua")
    self.poison_touch = caster:FindAbilityByName("dazzle_poison_touch_lua")
    if (special_shadow_wave_poison_touch_lua and special_shadow_wave_poison_touch_lua:GetLevel() ~= 0 and self.poison_touch and self.poison_touch:GetLevel() > 0) then
        self.special_shadow_wave_poison_touch_lua = special_shadow_wave_poison_touch_lua:GetSpecialValueFor("value")
    end

    -- precache damage
    self.damageTable = {
        -- victim = target,
        attacker = caster,
        damage = self.damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }

    -- unit groups
    self.healedUnits = {}
    table.insert(self.healedUnits, caster)

    -- Jump
    self:Jump(jumps, caster, target)

    -- Play effects
    local sound_cast = "Hero_Dazzle.Shadow_Wave"
    EmitSoundOn(sound_cast, caster)
end

function dazzle_shadow_wave_lua:Jump(jumps, source, target)
    -- Heal
    source:Heal(self.damage, self)
    -- Talent tree
    if self.special_shadow_wave_shallow_grave_lua ~= 0 then
        -- add shallow grave
        source:AddNewModifier(
                self:GetCaster(), -- player source
                self.shallow_grave, -- ability source
                "modifier_dazzle_shallow_grave_lua", -- modifier name
                { duration = self.special_shadow_wave_shallow_grave_lua } -- kv
        )
    end

    -- Find enemy nearby
    local enemies = FindUnitsInRadius(
            source:GetTeamNumber(), -- int, your team number
            source:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- Damage
    for _, enemy in pairs(enemies) do
        self.damageTable.victim = enemy
        ApplyDamage(self.damageTable)
        -- Talent tree
        if self.special_shadow_wave_poison_touch_lua ~= 0 then
            -- add poison touch
            enemy:AddNewModifier(
                    self:GetCaster(), -- player source
                    self.poison_touch, -- ability source
                    "modifier_dazzle_poison_touch_lua", -- modifier name
                    { duration = self.special_shadow_wave_poison_touch_lua } -- kv
            )
        end

        -- Play effects
        self:PlayEffects2(enemy)
    end

    -- counter
    local jump = jumps - 1
    if jump < 0 then
        return
    end

    -- next target
    local nextTarget = nil
    if target and target ~= source then
        nextTarget = target
    else
        -- Find ally nearby
        local allies = FindUnitsInRadius(
                source:GetTeamNumber(), -- int, your team number
                source:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                self.bounce_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbilityTargetTeam(), -- int, team filter
                self:GetAbilityTargetType(), -- int, type filter
                0, -- int, flag filter
                FIND_CLOSEST, -- int, order filter
                false    -- bool, can grow cache
        )

        for _, ally in pairs(allies) do
            local pass = false
            for _, unit in pairs(self.healedUnits) do
                if ally == unit then
                    pass = true
                end
            end

            if not pass then
                nextTarget = ally
                break
            end
        end
    end

    if nextTarget then
        table.insert(self.healedUnits, nextTarget)
        self:Jump(jump, nextTarget)
    end

    -- Play effects
    self:PlayEffects1(source, nextTarget)

end

--------------------------------------------------------------------------------
function dazzle_shadow_wave_lua:PlayEffects1(source, target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"

    if not target then
        target = source
    end

    -- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, source )
    local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, source)
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            source,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            source:GetOrigin(), -- unknown
            true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            1,
            target,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            target:GetOrigin(), -- unknown
            true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex(effect_cast)
end

function dazzle_shadow_wave_lua:PlayEffects2(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"

    -- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            target,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            target:GetOrigin(), -- unknown
            true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex(effect_cast)
end