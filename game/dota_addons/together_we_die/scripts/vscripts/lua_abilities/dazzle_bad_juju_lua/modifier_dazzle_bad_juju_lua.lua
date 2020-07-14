modifier_dazzle_bad_juju_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_bad_juju_lua:IsHidden()
    return true
end

function modifier_dazzle_bad_juju_lua:IsDebuff()
    return false
end

function modifier_dazzle_bad_juju_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dazzle_bad_juju_lua:OnCreated(kv)
    -- references
    self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
    self.max_cooldown_reduction = self:GetAbility():GetSpecialValueFor("max_cooldown_reduction")
    self.cd_int_multiplier = self:GetAbility():GetSpecialValueFor("cd_int_multiplier")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")

    if not IsServer() then
        return
    end
    local interval = 1
    -- Start interval
    self:StartIntervalThink(interval)
end

function modifier_dazzle_bad_juju_lua:OnRefresh(kv)
    -- references
    self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
    self.max_cooldown_reduction = self:GetAbility():GetSpecialValueFor("max_cooldown_reduction")
    self.cd_int_multiplier = self:GetAbility():GetSpecialValueFor("cd_int_multiplier")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_dazzle_bad_juju_lua:OnRemoved()
end

function modifier_dazzle_bad_juju_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_bad_juju_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }

    return funcs
end

function modifier_dazzle_bad_juju_lua:GetModifierPercentageCooldown()
    if IsServer() then
        self:UpdateMaxCdr()
    end

    if not self:GetCaster():PassivesDisabled() then
        return self:GetStackCount()
    end

    return 0
end

function modifier_dazzle_bad_juju_lua:OnIntervalThink()
    self:UpdateMaxCdr()
end

function modifier_dazzle_bad_juju_lua:UpdateMaxCdr()
    local max_cooldown_reduction = self.max_cooldown_reduction
    -- Talent tree
    local special_bad_juju_max_cdr_lua = self:GetParent():FindAbilityByName("special_bad_juju_max_cdr_lua")
    if (special_bad_juju_max_cdr_lua and special_bad_juju_max_cdr_lua:GetLevel() ~= 0) then
        max_cooldown_reduction = max_cooldown_reduction + special_bad_juju_max_cdr_lua:GetSpecialValueFor("value")
    end
    self:SetStackCount(math.min(math.floor(self:GetParent():GetIntellect() * self.cd_int_multiplier) + self.cooldown_reduction, max_cooldown_reduction))
    self:ForceRefresh()
end

function modifier_dazzle_bad_juju_lua:OnAbilityFullyCast(params)
    local caster = self:GetCaster()
    if params.unit ~= caster then
        return
    end
    if params.ability == self:GetAbility() then
        return
    end

    -- cancel if break
    if caster:PassivesDisabled() then
        return
    end

    -- Find targets near caster and give debuff stack
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            self:GetParent():GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
            self:GetAbility():GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    for _, enemy in pairs(enemies) do
        -- reduce armor
        enemy:AddNewModifier(
                caster, -- player source
                self:GetAbility(), -- ability source
                "modifier_dazzle_bad_juju_lua_debuff", -- modifier name
                { duration = self.duration } -- kv
        )
    end

    if self:GetParent():HasScepter() then
        -- launch attack projectile to all enemies nearbys
        -- get radius
        local attack_radius = caster:Script_GetAttackRange()

        -- find other target units
        local attack_enemies = FindUnitsInRadius(
                caster:GetTeamNumber(), -- int, your team number
                caster:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                attack_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER, -- int, type filter
                DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )
        -- get targets
        for _, enemy in pairs(attack_enemies) do
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
        end
    end
end