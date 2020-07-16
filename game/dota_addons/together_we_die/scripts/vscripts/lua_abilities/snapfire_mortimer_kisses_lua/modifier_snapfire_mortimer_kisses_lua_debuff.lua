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
modifier_snapfire_mortimer_kisses_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_mortimer_kisses_lua_debuff:IsHidden()
    return false
end

function modifier_snapfire_mortimer_kisses_lua_debuff:IsDebuff()
    return true
end

function modifier_snapfire_mortimer_kisses_lua_debuff:IsStunDebuff()
    return false
end

function modifier_snapfire_mortimer_kisses_lua_debuff:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_mortimer_kisses_lua_debuff:OnCreated(kv)
    -- references
    self.slow = -self:GetAbility():GetSpecialValueFor("move_slow_pct")

    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local interval = self:GetAbility():GetSpecialValueFor("burn_interval")
    self.burn_str_multiplier = self:GetAbility():GetSpecialValueFor("burn_str_multiplier")
    -- Talent Tree
    local special_mortimer_kisses_burn_str_multiplier_lua = caster:FindAbilityByName("special_mortimer_kisses_burn_str_multiplier_lua")
    if special_mortimer_kisses_burn_str_multiplier_lua and special_mortimer_kisses_burn_str_multiplier_lua:GetLevel() ~= 0 then
        self.burn_str_multiplier = self.burn_str_multiplier + special_mortimer_kisses_burn_str_multiplier_lua:GetSpecialValueFor("value")
    end
    self.dps = self:GetAbility():GetSpecialValueFor("burn_damage") + math.floor(caster:GetStrength() * self.burn_str_multiplier)

    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = caster,
        damage = self.dps * interval,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }

    -- Start interval
    self:StartIntervalThink(interval)
    self:OnIntervalThink()
end

function modifier_snapfire_mortimer_kisses_lua_debuff:OnRefresh(kv)

end

function modifier_snapfire_mortimer_kisses_lua_debuff:OnRemoved()
end

function modifier_snapfire_mortimer_kisses_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_snapfire_mortimer_kisses_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_snapfire_mortimer_kisses_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_snapfire_mortimer_kisses_lua_debuff:OnIntervalThink()
    -- apply damage
    ApplyDamage(self.damageTable)

    -- play overhead
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_snapfire_mortimer_kisses_lua_debuff:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf"
end

function modifier_snapfire_mortimer_kisses_lua_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_snapfire_mortimer_kisses_lua_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_magma.vpcf"
end

function modifier_snapfire_mortimer_kisses_lua_debuff:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end