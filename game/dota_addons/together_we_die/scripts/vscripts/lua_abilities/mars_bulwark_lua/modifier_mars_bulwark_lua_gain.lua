modifier_mars_bulwark_lua_gain = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_bulwark_lua_gain:IsHidden()
    return false
end

function modifier_mars_bulwark_lua_gain:IsDebuff()
    return false
end

function modifier_mars_bulwark_lua_gain:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_bulwark_lua_gain:OnCreated(kv)
    -- references
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_mars_bulwark_lua_gain:OnRefresh(kv)
    -- references
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_mars_bulwark_lua_gain:OnDestroy(kv)
end

function modifier_mars_bulwark_lua_gain:RemoveOnDeath()
    return false
end

function modifier_mars_bulwark_lua_gain:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_bulwark_lua_gain:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function modifier_mars_bulwark_lua_gain:GetModifierHealthBonus()
    return self:GetStackCount() * math.floor(self.str_multiplier * self:GetParent():GetStrength())
end
