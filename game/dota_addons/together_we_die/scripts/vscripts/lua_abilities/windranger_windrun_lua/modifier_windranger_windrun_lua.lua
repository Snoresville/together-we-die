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
modifier_windranger_windrun_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_windranger_windrun_lua:IsHidden()
    return false
end

function modifier_windranger_windrun_lua:IsDebuff()
    return false
end

function modifier_windranger_windrun_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_windranger_windrun_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.evasion = self:GetAbility():GetSpecialValueFor("evasion_pct_tooltip")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.ms_max = 550

    self.aura_duration = 2.5

    if self:GetCaster():HasScepter() then
        local ms_bonus_scepter = self:GetAbility():GetSpecialValueFor("scepter_bonus_movement")
        self.ms_bonus = self.ms_bonus + ms_bonus_scepter
        self.ms_max = self.ms_max * 2
    end
end

function modifier_windranger_windrun_lua:OnRefresh(kv)
    -- same as oncreated
    self:OnCreated(kv)
end

function modifier_windranger_windrun_lua:OnRemoved()
end

function modifier_windranger_windrun_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_windranger_windrun_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_windranger_windrun_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus
end
function modifier_windranger_windrun_lua:GetModifierEvasion_Constant()
    return self.evasion
end
function modifier_windranger_windrun_lua:GetModifierPreAttack_BonusDamage()
    return self:GetCaster():GetIntellect() * self.int_multiplier
end
function modifier_windranger_windrun_lua:GetModifierMoveSpeed_Limit()
    return self.ms_max
end
function modifier_windranger_windrun_lua:GetModifierMoveSpeed_Max()
    return self.ms_max
end

-- --------------------------------------------------------------------------------
-- -- Status Effects
-- function modifier_windranger_windrun_lua:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_INVULNERABLE] = true,
-- 	}

-- 	return state
-- end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_windranger_windrun_lua:IsAura()
    return true
end

function modifier_windranger_windrun_lua:GetModifierAura()
    return "modifier_windranger_windrun_lua_debuff"
end

function modifier_windranger_windrun_lua:GetAuraRadius()
    return self.radius
end

function modifier_windranger_windrun_lua:GetAuraDuration()
    return self.aura_duration
end

function modifier_windranger_windrun_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_windranger_windrun_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_windranger_windrun_lua:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_windranger_windrun_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end