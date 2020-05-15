modifier_abaddon_frostmourne_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_frostmourne_lua_buff:IsHidden()
    return false
end

function modifier_abaddon_frostmourne_lua_buff:IsPurgable()
    return true
end

function modifier_abaddon_frostmourne_lua_buff:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_frostmourne_lua_buff:OnCreated(kv)
    -- references
    self.curse_attack_speed = self:GetAbility():GetSpecialValueFor("curse_attack_speed")

    if not IsServer() then
        return
    end
    --self:PlayEffects()
end

function modifier_abaddon_frostmourne_lua_buff:OnRefresh(kv)
    -- references
    self.curse_attack_speed = self:GetAbility():GetSpecialValueFor("curse_attack_speed")

    if not IsServer() then
        return
    end
    --self:PlayEffects()
end

function modifier_abaddon_frostmourne_lua_buff:OnDestroy(kv)
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_frostmourne_lua_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_abaddon_frostmourne_lua_buff:GetModifierAttackSpeedBonus_Constant()
    return self.curse_attack_speed
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_abaddon_frostmourne_lua_buff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf"
end

function modifier_abaddon_frostmourne_lua_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
