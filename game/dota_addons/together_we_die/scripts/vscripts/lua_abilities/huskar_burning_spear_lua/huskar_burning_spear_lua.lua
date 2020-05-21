-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
huskar_burning_spear_lua = class({})
LinkLuaModifier("modifier_huskar_burning_spear_lua", "lua_abilities/huskar_burning_spear_lua/modifier_huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function huskar_burning_spear_lua:GetIntrinsicModifierName()
    return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function huskar_burning_spear_lua:CastFilterResultTarget(hTarget)
    if not IsServer() then
        return UF_SUCCESS
    end

    local nResult = UnitFilter(
            hTarget,
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            self:GetAbilityTargetFlags(),
            self:GetCaster():GetTeamNumber()
    )
    if nResult ~= UF_SUCCESS then
        return nResult
    end

    return UF_SUCCESS
end

-- AOE Radius
function huskar_burning_spear_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Orb Effects
function huskar_burning_spear_lua:GetProjectileName()
    return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

function huskar_burning_spear_lua:OnOrbFire(params)
    local str_multiplier = self:GetSpecialValueFor("str_multiplier")
    local base_dps = self:GetSpecialValueFor("burn_damage")
    local total_dps = base_dps + self:GetCaster():GetStrength() * str_multiplier
    local self_dmg = total_dps * self:GetSpecialValueFor("self_dmg_multiplier")
    -- health cost
    local damageTable = {
        victim = self:GetCaster(),
        attacker = self:GetCaster(),
        damage = self:GetSpecialValueFor("health_cost") + self_dmg,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self, --Optional.
        damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
    }
    ApplyDamage(damageTable)

    -- play effects
    local sound_cast = "Hero_Huskar.Burning_Spear.Cast"
    EmitSoundOn(sound_cast, caster)
end

function huskar_burning_spear_lua:OnOrbImpact(params)
    local duration = self:GetDuration()
    local caster = self:GetCaster()
    local target = params.target

    local search = self:GetSpecialValueFor("radius")
    local targets = FindUnitsInRadius(
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

    for _, enemy in pairs(targets) do
        enemy:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_huskar_burning_spear_lua", -- modifier name
                { duration = duration } -- kv
        )
    end

    -- play effects
    local sound_cast = "Hero_Huskar.Burning_Spear"
    EmitSoundOn(sound_cast, target)
end