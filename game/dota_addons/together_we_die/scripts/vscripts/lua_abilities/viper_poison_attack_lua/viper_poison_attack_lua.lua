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
viper_poison_attack_lua = class({})
LinkLuaModifier("modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_viper_poison_attack_lua", "lua_abilities/viper_poison_attack_lua/modifier_viper_poison_attack_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function viper_poison_attack_lua:GetIntrinsicModifierName()
    return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function viper_poison_attack_lua:CastFilterResultTarget(hTarget)
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
function viper_poison_attack_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Orb Effects
function viper_poison_attack_lua:GetProjectileName()
    return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end

function viper_poison_attack_lua:OnOrbFire(params)
    -- play effects
    local sound_cast = "hero_viper.poisonAttack.Cast"
    EmitSoundOn(sound_cast, self:GetCaster())
end

function viper_poison_attack_lua:OnOrbImpact(params)
    -- references
    local duration = self:GetSpecialValueFor("duration")
    local poison_attack_modifier = "modifier_viper_poison_attack_lua"

    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            params.target:GetOrigin(),
            nil,
            self:GetSpecialValueFor("radius"),
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            self:GetAbilityTargetFlags(),
            0,
            false
    )
    for _, enemy in pairs(enemies) do
        -- Apply debuff to enemy
        local debuff_modifier = enemy:FindModifierByName(poison_attack_modifier)
        if debuff_modifier then
            debuff_modifier:IncrementStackCount()
            debuff_modifier:ForceRefresh()
        else
            enemy:AddNewModifier(
                    self:GetCaster(),
                    self,
                    poison_attack_modifier,
                    {
                        duration = duration,
                    }
            )
        end

        -- play effects
        local sound_cast = "hero_viper.poisonAttack.Target"
        EmitSoundOn(sound_cast, enemy)
    end
end