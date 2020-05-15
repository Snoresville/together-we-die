modifier_tower_spawn_protection = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tower_spawn_protection:IsHidden()
    return true
end

function modifier_tower_spawn_protection:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tower_spawn_protection:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_tower_spawn_protection:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_tower_spawn_protection:OnDestroy(kv)

end

function modifier_tower_spawn_protection:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------
-- Classifications
function modifier_tower_spawn_protection:IsHidden()
    return true
end

function modifier_tower_spawn_protection:IsDebuff()
    return false
end

function modifier_tower_spawn_protection:IsPurgable()
    return false
end

function modifier_tower_spawn_protection:IsAura()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetModifierAura()
    return "modifier_tower_spawn_protection_effect"
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraEntityReject(hEntity)
    -- prevent units spawned that cannot move from being invulnerable
    if self:GetCaster() ~= hEntity and not hEntity:HasMovementCapability() then
        return true
    end

    return false
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraRadius()
    return self.radius
end