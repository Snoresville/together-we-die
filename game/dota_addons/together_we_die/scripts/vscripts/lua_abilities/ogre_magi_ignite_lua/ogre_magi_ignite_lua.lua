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
ogre_magi_ignite_lua = class({})
LinkLuaModifier("modifier_ogre_magi_ignite_lua", "lua_abilities/ogre_magi_ignite_lua/modifier_ogre_magi_ignite_lua", LUA_MODIFIER_MOTION_NONE)

function ogre_magi_ignite_lua:GetAOERadius()
    return self:GetSpecialValueFor("ignite_aoe")
end

--------------------------------------------------------------------------------
-- Ability Start
function ogre_magi_ignite_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local projectile_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
    local projectile_speed = self:GetSpecialValueFor("projectile_speed")

    -- create projectile
    local info = {
        Target = target,
        Source = caster,
        Ability = self,

        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bDodgeable = true, -- Optional
    }
    ProjectileManager:CreateTrackingProjectile(info)

    -- find secondary target
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            caster:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self:GetCastRange(target:GetOrigin(), target), -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    local target_2 = nil
    for _, enemy in pairs(enemies) do
        -- only target those who does not have debuff
        if enemy ~= target and (not enemy:HasModifier("modifier_ogre_magi_ignite_lua")) then
            target_2 = enemy
            break
        end
    end

    -- create secondary projectile
    if target_2 then
        info.Target = target_2
        ProjectileManager:CreateTrackingProjectile(info)
    end

    -- play effects
    local sound_cast = "Hero_OgreMagi.Ignite.Cast"
    EmitSoundOn(sound_cast, caster)
end

--------------------------------------------------------------------------------
-- Projectile
function ogre_magi_ignite_lua:OnProjectileHit(target, location)
    if not target then
        return
    end

    -- cancel if linken
    if target:TriggerSpellAbsorb(self) then
        return
    end

    -- load data
    local duration = self:GetSpecialValueFor("duration")
    local caster = self:GetCaster()

    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self:GetSpecialValueFor("ignite_aoe"), -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    for _, enemy in pairs(enemies) do
        -- add debuff
        enemy:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_ogre_magi_ignite_lua", -- modifier name
                { duration = duration } -- kv
        )
    end

    -- play effects
    local sound_cast = "Hero_OgreMagi.Ignite.Target"
    EmitSoundOn(sound_cast, caster)
end