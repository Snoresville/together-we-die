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
modifier_medusa_split_shot_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_split_shot_lua:IsHidden()
    return true
end

function modifier_medusa_split_shot_lua:IsPurgable()
    return false
end

function modifier_medusa_split_shot_lua:GetPriority()
    return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_medusa_split_shot_lua:OnCreated(kv)
    -- references
    self.reduction = self:GetAbility():GetSpecialValueFor("damage_modifier")
    self.count = self:GetAbility():GetSpecialValueFor("arrow_count")
    self.bonus_range = self:GetAbility():GetSpecialValueFor("split_shot_bonus_range")

    self.parent = self:GetParent()

    self.use_modifier = false
    -- Talent Tree
    self.count_needed = true
    self.mystic_snake_proc_chance = 0
    self.special_split_shot_damage_lua = 0

    if not IsServer() then
        return
    end
    self.projectile_name = self.parent:GetRangedProjectileName()
    self.projectile_speed = self.parent:GetProjectileSpeed()
    -- start interval
    self:OnIntervalThink()
    local interval = 1
    self:StartIntervalThink(interval)
end

function modifier_medusa_split_shot_lua:OnRefresh(kv)
    -- references
    self.reduction = self:GetAbility():GetSpecialValueFor("damage_modifier")
    self.count = self:GetAbility():GetSpecialValueFor("arrow_count")
    self.bonus_range = self:GetAbility():GetSpecialValueFor("split_shot_bonus_range")
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_medusa_split_shot_lua:OnRemoved()
end

function modifier_medusa_split_shot_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_medusa_split_shot_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,

        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_medusa_split_shot_lua:OnAttack(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self.parent then
        return
    end

    -- not proc for instant attacks
    if params.no_attack_cooldown then
        return
    end

    -- not proc for attacking allies
    if params.target:GetTeamNumber() == params.attacker:GetTeamNumber() then
        return
    end

    -- not proc if break
    if self.parent:PassivesDisabled() then
        return
    end

    -- not proc if attack can't use attack modifiers
    -- if not params.process_procs then return end

    -- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
    if self.split_shot then
        return
    end

    -- split shot
    if self.use_modifier then
        self:SplitShotModifier(params.target)
    else
        self:SplitShotNoModifier(params.target)
    end
end

function modifier_medusa_split_shot_lua:GetModifierDamageOutgoing_Percentage()
    if not IsServer() then
        return
    end

    -- if uses modifier
    if self.split_shot then
        return self.reduction + self.special_split_shot_damage_lua
    end

    -- if not use modifier
    if self:GetAbility().split_shot_attack then
        return self.reduction + self.special_split_shot_damage_lua
    end
end
--------------------------------------------------------------------------------
-- Helper
--[[
	NOTE:
	- PerformAttack will use projectile particle from items, even if it actually not using attack modifiers
	- Split shot without attack modifier uses regular tracking projectile, then perform instant attacks on projectile hit
	- Therefore, SplitShotModifier and SplitShotNoModifier are separated JUST BECAUSE of projectile effects.
]]
function modifier_medusa_split_shot_lua:SplitShotModifier(target)
    -- get radius
    local radius = self.parent:Script_GetAttackRange() + self.bonus_range

    -- find other target units
    local enemies = FindUnitsInRadius(
            self.parent:GetTeamNumber(), -- int, your team number
            self.parent:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- get targets
    local count = 0
    for _, enemy in pairs(enemies) do
        -- not target itself
        if enemy ~= target then

            -- perform attack
            self.split_shot = true
            self.parent:PerformAttack(
                    enemy, -- hTarget
                    false, -- bUseCastAttackOrb
                    self.use_modifier, -- bProcessProcs
                    true, -- bSkipCooldown
                    false, -- bIgnoreInvis
                    true, -- bUseProjectile
                    false, -- bFakeAttack
                    false -- bNeverMiss
            )
            self.split_shot = false
            self:ProcMysticSnake(enemy)

            count = count + 1
            if self.count_needed and count >= self.count then
                break
            end
        end
    end

    -- play effects if splitshot
    if count > 0 then
        local sound_cast = "Hero_Medusa.AttackSplit"
        EmitSoundOn(sound_cast, self.parent)
    end
end

function modifier_medusa_split_shot_lua:SplitShotNoModifier(target)
    -- get radius
    local radius = self.parent:Script_GetAttackRange() + self.bonus_range

    -- find other target units
    local enemies = FindUnitsInRadius(
            self.parent:GetTeamNumber(), -- int, your team number
            self.parent:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- get targets
    local count = 0
    for _, enemy in pairs(enemies) do
        -- not target itself
        if enemy ~= target then
            -- launch projectile
            local info = {
                Target = enemy,
                Source = self.parent,
                Ability = self:GetAbility(),

                EffectName = self.projectile_name,
                iMoveSpeed = self.projectile_speed,
                bDodgeable = true, -- Optional
                -- bIsAttack = true,                                -- Optional
            }
            ProjectileManager:CreateTrackingProjectile(info)
            self:ProcMysticSnake(enemy)

            count = count + 1
            if self.count_needed and count >= self.count then
                break
            end
        end
    end

    -- play effects if splitshot
    if count > 0 then
        local sound_cast = "Hero_Medusa.AttackSplit"
        EmitSoundOn(sound_cast, self.parent)
    end
end

function modifier_medusa_split_shot_lua:ProcMysticSnake(target)
    if self.mystic_snake_proc_chance ~= 0 then
        local medusa_mystic_snake_lua = self:GetParent():FindAbilityByName("medusa_mystic_snake_lua")
        if medusa_mystic_snake_lua and RandomInt(0, 100) < self.mystic_snake_proc_chance then
            -- cast to target
            self:GetParent():SetCursorCastTarget(target)
            medusa_mystic_snake_lua:OnSpellStart()
        end
    end
end

function modifier_medusa_split_shot_lua:OnIntervalThink()
    local medusa_split_shot_uses_modifiers = self:GetParent():FindAbilityByName("medusa_split_shot_uses_modifiers_lua")
    if (medusa_split_shot_uses_modifiers and medusa_split_shot_uses_modifiers:GetLevel() ~= 0) then
        self.use_modifier = true
    else
        self.use_modifier = false
    end

    local special_split_shot_no_limit_lua = self:GetParent():FindAbilityByName("special_split_shot_no_limit_lua")
    if (special_split_shot_no_limit_lua and special_split_shot_no_limit_lua:GetLevel() ~= 0) then
        self.count_needed = false
    else
        self.count_needed = true
    end

    local special_split_shot_procs_mystic_snake_lua = self:GetParent():FindAbilityByName("special_split_shot_procs_mystic_snake_lua")
    if (special_split_shot_procs_mystic_snake_lua and special_split_shot_procs_mystic_snake_lua:GetLevel() ~= 0) then
        self.mystic_snake_proc_chance = special_split_shot_procs_mystic_snake_lua:GetSpecialValueFor("value")
    else
        self.mystic_snake_proc_chance = 0
    end

    local special_split_shot_damage_lua = self:GetParent():FindAbilityByName("special_split_shot_damage_lua")
    if (special_split_shot_damage_lua and special_split_shot_damage_lua:GetLevel() ~= 0) then
        self.special_split_shot_damage_lua = special_split_shot_damage_lua:GetSpecialValueFor("value")
    else
        self.special_split_shot_damage_lua = 0
    end
end