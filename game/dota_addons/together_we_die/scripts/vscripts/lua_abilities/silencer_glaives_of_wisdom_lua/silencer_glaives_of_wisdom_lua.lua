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
silencer_glaives_of_wisdom_lua = class({})
LinkLuaModifier("modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_glaives_of_wisdom_lua", "lua_abilities/silencer_glaives_of_wisdom_lua/modifier_silencer_glaives_of_wisdom_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function silencer_glaives_of_wisdom_lua:GetIntrinsicModifierName()
    return "modifier_silencer_glaives_of_wisdom_lua"
end

function silencer_glaives_of_wisdom_lua:GetAbilityTargetFlags()
    local targetFlags = DOTA_UNIT_TARGET_FLAG_NONE

    if self:GetCaster():HasScepter() then
        targetFlags = targetFlags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end

    return targetFlags
end
--------------------------------------------------------------------------------
-- Ability Cast Filter
function silencer_glaives_of_wisdom_lua:CastFilterResultTarget(hTarget)
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

--------------------------------------------------------------------------------
-- Ability Start
function silencer_glaives_of_wisdom_lua:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function silencer_glaives_of_wisdom_lua:GetProjectileName()
    return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end

function silencer_glaives_of_wisdom_lua:OnOrbFire(params)
    -- play effects
    local sound_cast = "Hero_Silencer.GlaivesOfWisdom"
    EmitSoundOn(sound_cast, self:GetCaster())
end

function silencer_glaives_of_wisdom_lua:OnOrbImpact(params)
    local caster = self:GetCaster()

    -- get damage
    local int_mult = self:GetSpecialValueFor("intellect_damage_pct")
    local scepter_damage_multiplier = self:GetSpecialValueFor("scepter_damage_multiplier")
    local damage = math.floor(caster:GetIntellect() * int_mult / 100)
    if caster:HasScepter() and params.target:IsSilenced() then
        damage = damage * scepter_damage_multiplier
    end

    -- apply damage
    local damageTable = {
        victim = params.target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    -- overhead message
    SendOverheadEventMessage(
            nil,
            OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
            params.target,
            damage,
            nil
    )

    -- play effects
    local sound_cast = "Hero_Silencer.GlaivesOfWisdom.Damage"
    EmitSoundOn(sound_cast, params.target)
end

function silencer_glaives_of_wisdom_lua:GetGlaivesKills()
    if self.nKills == nil then
        self.nKills = 0
    end
    return self.nKills
end

function silencer_glaives_of_wisdom_lua:IncrementGlaivesKills()
    self.nKills = self:GetGlaivesKills() + 1
end

--------------------------------------------------------------------------------
-- Hero Events
-- function silencer_glaives_of_wisdom_lua:OnHeroCalculateStatBonus()

-- end

--------------------------------------------------------------------------------
-- Other Events
-- function silencer_glaives_of_wisdom_lua:OnHeroDiedNearby(handle unit, handle attacker, handle table)

-- end