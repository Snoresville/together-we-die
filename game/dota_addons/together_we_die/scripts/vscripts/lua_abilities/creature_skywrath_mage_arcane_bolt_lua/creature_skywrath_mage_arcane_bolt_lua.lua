creature_skywrath_mage_arcane_bolt_lua = class({})

--------------------------------------------------------------------------------
function creature_skywrath_mage_arcane_bolt_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
--------------------------------------------------------------------------------
-- Ability Start
function creature_skywrath_mage_arcane_bolt_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local base_damage = self:GetSpecialValueFor("bolt_damage")
    local radius = self:GetSpecialValueFor("radius")

    -- calculate damage
    local damage = base_damage

    self:SearchAndProjectile(caster, target, radius, damage)

    -- scepter effect
	local secondary_radius = self:GetSpecialValueFor( "secondary_radius" )

    -- find nearby enemies
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            secondary_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            self:GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- 'enemies' will only have at max 1 hero (others are creeps), which would be 'target'
    local target_2 = enemies[1]        -- could be nil
    if target_2 == target then
        target_2 = enemies[2]    -- could be nil
    end

    if target_2 then
        -- launch projectile
        self:SearchAndProjectile(caster, target_2, radius, damage)
    end

    -- play effects
    local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
    EmitSoundOn(sound_cast, caster)
end
--------------------------------------------------------------------------------
-- Projectile
function creature_skywrath_mage_arcane_bolt_lua:OnProjectileHit_ExtraData(target, location, extraData)
    if not target then
        return
    end

    -- cancel if linken
    if target:TriggerSpellAbsorb(self) then
        return
    end

    -- apply damage
    local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = extraData.damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    -- vision
    local vision = self:GetSpecialValueFor("bolt_vision")
    local duration = self:GetSpecialValueFor("vision_duration")
    AddFOWViewer(
            self:GetCaster():GetTeamNumber(), --nTeamID
            target:GetOrigin(), --vLocation
            vision, --flRadius
            duration, --flDuration
            false --bObstructedVision
    )

    -- play effects
    local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Impact"
    EmitSoundOn(sound_cast, target)

    local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
    StopSoundOn(sound_cast, self:GetCaster())
end

function creature_skywrath_mage_arcane_bolt_lua:SearchAndProjectile(caster, target, radius, damage)
    local projectile_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
    local projectile_speed = self:GetSpecialValueFor("bolt_speed")
    local projectile_vision = self:GetSpecialValueFor("bolt_vision")

    -- find enemies
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            target, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            self:GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    for _, enemy in pairs(enemies) do
        -- add debuff
        -- create projectile
        local info = {
            Target = enemy,
            Source = caster,
            Ability = self,

            EffectName = projectile_name,
            iMoveSpeed = projectile_speed,
            bDodgeable = false, -- Optional

            bVisibleToEnemies = true, -- Optional

            bProvidesVision = true, -- Optional
            iVisionRadius = projectile_vision, -- Optional
            iVisionTeamNumber = caster:GetTeamNumber(), -- Optional

            ExtraData = {
                damage = damage,
            }
        }
        ProjectileManager:CreateTrackingProjectile(info)
    end
end