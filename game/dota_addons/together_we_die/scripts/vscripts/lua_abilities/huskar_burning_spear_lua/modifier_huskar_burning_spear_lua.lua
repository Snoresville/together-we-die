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
modifier_huskar_burning_spear_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_burning_spear_lua:IsHidden()
    return false
end

function modifier_huskar_burning_spear_lua:IsDebuff()
    return true
end

function modifier_huskar_burning_spear_lua:IsStunDebuff()
    return false
end

function modifier_huskar_burning_spear_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_huskar_burning_spear_lua:OnCreated(kv)
    -- references
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    -- Talent Tree
    local special_burning_spear_str_multiplier_lua = self:GetCaster():FindAbilityByName("special_burning_spear_str_multiplier_lua")
    if special_burning_spear_str_multiplier_lua and special_burning_spear_str_multiplier_lua:GetLevel() ~= 0 then
        self.str_multiplier = self.str_multiplier + special_burning_spear_str_multiplier_lua:GetSpecialValueFor("value")
    end
    self.base_dps = self:GetAbility():GetSpecialValueFor("burn_damage")
    self.total_dps = self.base_dps + self:GetCaster():GetStrength() * self.str_multiplier

    if IsServer() then
        self:SetStackCount(1)

        -- precache damage
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            -- damage = 500,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        -- start interval
        local interval = 1.0
        self:StartIntervalThink(interval)
    end
end

function modifier_huskar_burning_spear_lua:OnRefresh(kv)
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    -- Talent Tree
    local special_burning_spear_str_multiplier_lua = self:GetCaster():FindAbilityByName("special_burning_spear_str_multiplier_lua")
    if special_burning_spear_str_multiplier_lua and special_burning_spear_str_multiplier_lua:GetLevel() ~= 0 then
        self.str_multiplier = self.str_multiplier + special_burning_spear_str_multiplier_lua:GetSpecialValueFor("value")
    end
    self.base_dps = self:GetAbility():GetSpecialValueFor("burn_damage")
    self.total_dps = self.base_dps + self:GetCaster():GetStrength() * self.str_multiplier

    if IsServer() then
        self:IncrementStackCount()
    end
end

function modifier_huskar_burning_spear_lua:OnRemoved()
    -- stop effects
    local sound_cast = "Hero_Huskar.Burning_Spear"
    StopSoundOn(sound_cast, self:GetParent())
end

function modifier_huskar_burning_spear_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_huskar_burning_spear_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }

    return funcs
end

function modifier_huskar_burning_spear_lua:OnTooltip()
    return self:GetStackCount() * self.total_dps
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_huskar_burning_spear_lua:OnIntervalThink()
    -- apply dot damage
    self.damageTable.damage = self:GetStackCount() * self.total_dps
    ApplyDamage(self.damageTable)
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_huskar_burning_spear_lua:GetEffectName()
    return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_huskar_burning_spear_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end