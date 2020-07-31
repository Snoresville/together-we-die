modifier_creature_slark_shadow_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_shadow_dance_lua:IsHidden()
    return true
end

function modifier_creature_slark_shadow_dance_lua:IsDebuff()
    return false
end

function modifier_creature_slark_shadow_dance_lua:IsPurgable()
    return false
end
function modifier_creature_slark_shadow_dance_lua:GetPriority()
    return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Aura
function modifier_creature_slark_shadow_dance_lua:IsAura()
    -- Will not be disabled even if break
    return true
end

function modifier_creature_slark_shadow_dance_lua:GetModifierAura()
    return "modifier_creature_slark_shadow_dance_lua_invis"
end

function modifier_creature_slark_shadow_dance_lua:GetAuraRadius()
    return self.radius
end

function modifier_creature_slark_shadow_dance_lua:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_creature_slark_shadow_dance_lua:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

function modifier_creature_slark_shadow_dance_lua:GetAuraDuration()
    return 0.5
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_shadow_dance_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius") -- special value
end

function modifier_creature_slark_shadow_dance_lua:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius") -- special value
end

function modifier_creature_slark_shadow_dance_lua:OnDestroy(kv)

end
