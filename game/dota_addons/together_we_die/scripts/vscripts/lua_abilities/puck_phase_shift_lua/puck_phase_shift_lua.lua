puck_phase_shift_lua = class({})
LinkLuaModifier("modifier_puck_phase_shift_lua", "lua_abilities/puck_phase_shift_lua/modifier_puck_phase_shift_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function puck_phase_shift_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local duration = self:GetSpecialValueFor("duration")

    -- launch attack projectile to all enemies nearbys
    -- get radius
    local radius = caster:Script_GetAttackRange()
    -- damage table
    local damageTable = {
        victim = nil,
        attacker = caster,
        damage = caster:GetIntellect() * self:GetSpecialValueFor("int_multiplier"),
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }

    -- find other target units
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            caster:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )
    -- get targets
    for _, enemy in pairs(enemies) do
        -- perform attack
        caster:PerformAttack(
                enemy, -- hTarget
                false, -- bUseCastAttackOrb
                true, -- bProcessProcs
                true, -- bSkipCooldown
                false, -- bIgnoreInvis
                true, -- bUseProjectile
                false, -- bFakeAttack
                false -- bNeverMiss
        )
        -- deal damage
        damageTable.victim = enemy
        ApplyDamage(damageTable)
    end

    -- dodge projectile
    ProjectileManager:ProjectileDodge(caster)

    -- add modifier
    self.modifier = caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_puck_phase_shift_lua", -- modifier name
            { duration = duration } -- kv
    )

    -- effects
    local sound_cast = "Hero_Puck.Phase_Shift"
    EmitSoundOn(sound_cast, caster)
end

--------------------------------------------------------------------------------
-- Ability Channeling
function puck_phase_shift_lua:OnChannelFinish(bInterrupted)
    if not self.modifier:IsNull() then
        self.modifier:Destroy()
    end

    local sound_cast = "Hero_Puck.Phase_Shift"
    StopSoundOn(sound_cast, self:GetCaster())
end