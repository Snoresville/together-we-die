modifier_roshan_god_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_god_lua:IsHidden()
    return true
end

function modifier_roshan_god_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_god_lua:OnCreated(kv)
    -- references
    self.min_hp = self:GetAbility():GetSpecialValueFor("min_hp")
end

function modifier_roshan_god_lua:OnRefresh(kv)
    -- references
    self.min_hp = self:GetAbility():GetSpecialValueFor("min_hp")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_god_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end

function modifier_roshan_god_lua:GetMinHealth()
    return self.min_hp
end