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
modifier_viper_nethertoxin_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_viper_nethertoxin_lua_debuff:IsHidden()
    return false
end

function modifier_viper_nethertoxin_lua_debuff:IsDebuff()
    return true
end

function modifier_viper_nethertoxin_lua_debuff:IsStunDebuff()
    return false
end

function modifier_viper_nethertoxin_lua_debuff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_viper_nethertoxin_lua_debuff:OnCreated(kv)
    -- references
    self.damage = self:GetAbility():GetSpecialValueFor("damage") + (self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agi_multiplier"))
    self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resistance")
    self:SetStackCount(1)

    if not IsServer() then
        return
    end

    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }

    -- Start interval
    local interval = 1.0
    self:StartIntervalThink(interval)
end

function modifier_viper_nethertoxin_lua_debuff:OnRefresh(kv)
    -- references
    self.damage = self:GetAbility():GetSpecialValueFor("damage") + (self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agi_multiplier"))
    self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resistance")

    if not IsServer() then
        return
    end

    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }
end

function modifier_viper_nethertoxin_lua_debuff:OnRemoved()
end

function modifier_viper_nethertoxin_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_viper_nethertoxin_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_viper_nethertoxin_lua_debuff:GetModifierMagicalResistanceBonus()
    return self.magic_resist
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_viper_nethertoxin_lua_debuff:CheckState()
    local state = {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_viper_nethertoxin_lua_debuff:OnIntervalThink()
    -- Apply damage
    self.damageTable.damage = self.damage * self:GetStackCount()
    ApplyDamage(self.damageTable)

    -- Play effects
    local sound_cast = "Hero_Viper.NetherToxin.Damage"
    EmitSoundOn(sound_cast, self:GetParent())

    self:IncrementStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_viper_nethertoxin_lua_debuff:GetEffectName()
    return "particles/units/heroes/hero_viper/viper_nethertoxin_debuff.vpcf"
end

function modifier_viper_nethertoxin_lua_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
