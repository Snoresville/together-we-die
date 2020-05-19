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
modifier_ogre_magi_ignite_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_ignite_lua:IsHidden()
    return false
end

function modifier_ogre_magi_ignite_lua:IsDebuff()
    return true
end

function modifier_ogre_magi_ignite_lua:IsStunDebuff()
    return false
end

function modifier_ogre_magi_ignite_lua:IsPurgable()
    return true
end

function modifier_ogre_magi_ignite_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_ignite_lua:OnCreated(kv)
    -- references
    self.slow = self:GetAbility():GetSpecialValueFor("slow_movement_speed_pct")
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    -- Talent Tree
    local special_ignite_int_multiplier_lua = self:GetCaster():FindAbilityByName("special_ignite_int_multiplier_lua")
    if special_ignite_int_multiplier_lua and special_ignite_int_multiplier_lua:GetLevel() ~= 0 then
        self.int_multiplier = self.int_multiplier + special_ignite_int_multiplier_lua:GetSpecialValueFor("value")
    end
    self.damage = self:GetAbility():GetSpecialValueFor("burn_damage") + (self:GetCaster():GetIntellect() * self.int_multiplier)

    if not IsServer() then
        return
    end

    local interval = 1

    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self, --Optional.
    }
    -- ApplyDamage(damageTable)

    -- Start interval
    self:StartIntervalThink(interval)
end

function modifier_ogre_magi_ignite_lua:OnRefresh(kv)
    -- references
    self.slow = self:GetAbility():GetSpecialValueFor("slow_movement_speed_pct")
    -- Talent Tree
    local special_ignite_slow_lua = self:GetCaster():FindAbilityByName("special_ignite_slow_lua")
    if special_ignite_slow_lua and special_ignite_slow_lua:GetLevel() ~= 0 then
        self.slow = self.slow + special_ignite_slow_lua:GetSpecialValueFor("value")
    end
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    -- Talent Tree
    local special_ignite_int_multiplier_lua = self:GetCaster():FindAbilityByName("special_ignite_int_multiplier_lua")
    if special_ignite_int_multiplier_lua and special_ignite_int_multiplier_lua:GetLevel() ~= 0 then
        self.int_multiplier = self.int_multiplier + special_ignite_int_multiplier_lua:GetSpecialValueFor("value")
    end
    self.damage = self:GetAbility():GetSpecialValueFor("burn_damage") + (self:GetCaster():GetIntellect() * self.int_multiplier)

    if not IsServer() then
        return
    end
    -- update damage
    self.damageTable.damage = self.damage
end

function modifier_ogre_magi_ignite_lua:OnRemoved()
end

function modifier_ogre_magi_ignite_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ogre_magi_ignite_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_ogre_magi_ignite_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ogre_magi_ignite_lua:OnIntervalThink()
    -- apply damage
    ApplyDamage(self.damageTable)

    -- play effects
    local sound_cast = "Hero_OgreMagi.Ignite.Damage"
    EmitSoundOn(sound_cast, self:GetParent())
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ogre_magi_ignite_lua:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_ogre_magi_ignite_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end