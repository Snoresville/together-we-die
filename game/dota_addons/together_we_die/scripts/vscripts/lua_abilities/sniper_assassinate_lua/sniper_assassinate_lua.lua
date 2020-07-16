sniper_assassinate_lua = class({})
LinkLuaModifier("modifier_sniper_assassinate_lua", "lua_abilities/sniper_assassinate_lua/modifier_sniper_assassinate_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper_assassinate_no_cast_time_lua", "lua_abilities/sniper_assassinate_lua/modifier_sniper_assassinate_no_cast_time_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function sniper_assassinate_lua:GetIntrinsicModifierName()
    return "modifier_sniper_assassinate_no_cast_time_lua"
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function sniper_assassinate_lua:GetAOERadius()
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("scepter_radius")
    end
    return 0
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function sniper_assassinate_lua:OnAbilityPhaseInterrupted()
    if self.modifier then
        local modifier = self:RetATValue(self.modifier)
        if not modifier:IsNull() then
            modifier:Destroy()
        end
        self.modifier = nil
    end
end

function sniper_assassinate_lua:GetCastPoint()
    if self:GetCaster():GetModifierStackCount("modifier_sniper_assassinate_no_cast_time_lua", self:GetCaster()) == 1 then
        return 0
    end
    return self:GetSpecialValueFor("total_cast_time_tooltip")
end

function sniper_assassinate_lua:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    local debuff_duration = 4

    local modifier = target:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_sniper_assassinate_lua", -- modifier name
            { duration = debuff_duration } -- kv
    )

    self.modifier = self:AddATValue(modifier)

    -- play effects
    local sound_cast = "Ability.AssassinateLoad"
    EmitSoundOnClient(sound_cast, caster:GetPlayerOwner())

    return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function sniper_assassinate_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    -- local point = self:GetCursorPosition()

    -- load data
    local projectile_name = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
    local projectile_speed = self:GetSpecialValueFor("projectile_speed")

    local info = {
        Target = target,
        Source = caster,
        Ability = self,

        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bDodgeable = true, -- Optional
        ExtraData = { modifier = self.modifier }
    }
    ProjectileManager:CreateTrackingProjectile(info)
    self.modifier = nil

    -- effects
    local sound_cast = "Ability.Assassinate"
    EmitSoundOn(sound_cast, caster)
    local sound_target = "Hero_Sniper.AssassinateProjectile"
    EmitSoundOn(sound_target, target)
end
--------------------------------------------------------------------------------
-- Projectile
function sniper_assassinate_lua:OnProjectileHit_ExtraData(target, location, extradata)
    -- cancel if gone
    if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb(self) then
        return
    end

    -- apply damage
    local caster = self:GetCaster()
    local agi_multiplier = self:GetSpecialValueFor("agi_multiplier")
    -- Talent Tree
    local special_assassinate_agi_multiplier_lua = caster:FindAbilityByName("special_assassinate_agi_multiplier_lua")
    if special_assassinate_agi_multiplier_lua and special_assassinate_agi_multiplier_lua:GetLevel() ~= 0 then
        agi_multiplier = agi_multiplier + special_assassinate_agi_multiplier_lua:GetSpecialValueFor("value")
    end
    local damage = self:GetAbilityDamage() + (caster:GetAgility() * agi_multiplier)
    local targets = {}
    if caster:HasScepter() then
        damage = damage + (caster:GetAverageTrueAttackDamage(target) * (self:GetSpecialValueFor('scepter_crit_bonus') / 100))

        local search = self:GetSpecialValueFor("scepter_radius")
        targets = FindUnitsInRadius(
                caster:GetTeamNumber(), -- int, your team number
                target:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                search, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbilityTargetTeam(), -- int, team filter
                self:GetAbilityTargetType(), -- int, type filter
                self:GetAbilityTargetFlags(), -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )
    else
        table.insert(targets, target)
    end

    local damageTable = {
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    for _, enemy in pairs(targets) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
        -- stun
        enemy:Interrupt()
    end

    local modifier = self:RetATValue(extradata.modifier)
    if not modifier:IsNull() then
        modifier:Destroy()
    end

    -- effects
    local sound_cast = "Hero_Sniper.AssassinateDamage"
    EmitSoundOn(sound_cast, target)
end

--------------------------------------------------------------------------------
-- Helper: Ability Table (AT)
function sniper_assassinate_lua:GetAT()
    if self.abilityTable == nil then
        self.abilityTable = {}
    end
    return self.abilityTable
end

function sniper_assassinate_lua:GetATEmptyKey()
    local table = self:GetAT()
    local i = 1
    while table[i] ~= nil do
        i = i + 1
    end
    return i
end

function sniper_assassinate_lua:AddATValue(value)
    local table = self:GetAT()
    local i = self:GetATEmptyKey()
    table[i] = value
    return i
end

function sniper_assassinate_lua:RetATValue(key)
    local table = self:GetAT()
    local ret = table[key]
    table[key] = nil
    return ret
end