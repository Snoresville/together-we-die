invoker_deafening_blast_lua = class({})

LinkLuaModifier("modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_generic_disarm_lua", "lua_abilities/generic/modifier_generic_disarm_lua", LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------
function invoker_deafening_blast_lua:GetBehavior()
    local behaviour = DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES

    if self:GetCaster():HasScepter() then
        behaviour = behaviour + DOTA_ABILITY_BEHAVIOR_NO_TARGET
    else
        behaviour = behaviour + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT
    end

    return behaviour
end
--------------------------------------------------------------------------------
-- Ability Start
function invoker_deafening_blast_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local projectile_distance = self:GetSpecialValueFor("travel_distance")
    local caster_position = caster:GetAbsOrigin()

    -- Talent tree
    local special_deafening_blast_instant_redial_lua = caster:FindAbilityByName("special_deafening_blast_instant_redial_lua")
    local talent_redial = false
    if (special_deafening_blast_instant_redial_lua and special_deafening_blast_instant_redial_lua:GetLevel() ~= 0) then
        talent_redial = true
    end

    if self:GetCaster():HasScepter() then
        local inner = Vector(projectile_distance, 0, 0)
        for i = 0, 11 do
            local location = caster_position + RotatePosition(Vector(0, 0, 0), QAngle(0, 30 * i, 0), inner)
            self:Blast(caster_position, location)
            -- Redial talent
            if talent_redial then
                self:Blast(location, caster_position)
            end
        end
    else
        local point = self:GetCursorPosition()
        self:Blast(caster_position, point)
    end

end

-- Ability Start
function invoker_deafening_blast_lua:Blast(starting_point, ending_point)
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local projectile_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
    local projectile_distance = self:GetSpecialValueFor("travel_distance")
    local projectile_speed = self:GetSpecialValueFor("travel_speed")
    local projectile_start_radius = self:GetSpecialValueFor("radius_start")
    local projectile_end_radius = self:GetSpecialValueFor("radius_end")
    local projectile_direction = (ending_point - starting_point):Normalized()

    local info = {
        Source = caster,
        Ability = self,
        vSpawnOrigin = starting_point,

        EffectName = projectile_name,
        fDistance = projectile_distance,
        fStartRadius = projectile_start_radius,
        fEndRadius = projectile_end_radius,
        bHasFrontalCone = true,
        vVelocity = projectile_direction * projectile_speed,

        bDeleteOnHit = false,
        bReplaceExisting = false,

        iUnitTargetTeam = self:GetAbilityTargetTeam(),
        iUnitTargetFlags = self:GetAbilityTargetFlags(),
        iUnitTargetType = self:GetAbilityTargetType(),

        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)

    -- Play effects
    local sound_cast = "Hero_Invoker.DeafeningBlast"
    EmitSoundOn(sound_cast, caster)
end

--------------------------------------------------------------------------------
-- Projectile
function invoker_deafening_blast_lua:OnProjectileHit(target, location)
    if not target or target:IsNull() or target == null or not target:IsAlive() then
        return
    end

    local damage = self:GetOrbSpecialValueFor("damage", "e") + self:GetCaster():GetIntellect() * self:GetOrbSpecialValueFor("int_multiplier", "e")
    local knockback_distance = self:GetOrbSpecialValueFor("knockback_distance", "q")
    local knockback_duration = self:GetOrbSpecialValueFor("knockback_duration", "q")
    local disarm_duration = self:GetOrbSpecialValueFor("disarm_duration", "w")

    -- Apply Damage
    local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    local enemyOrigin = target:GetOrigin()

    -- knockback
    target:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_knockback_lua", -- modifier name
            {
                duration = knockback_duration,
                distance = knockback_distance,
                height = 20,
                direction_x = enemyOrigin.x - location.x,
                direction_y = enemyOrigin.y - location.y,
            } -- kv
    )

    -- disarm
    target:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_disarm_lua", -- modifier name
            {
                duration = disarm_duration,
            }
    )
end
