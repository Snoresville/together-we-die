modifier_lycan_shapeshift_lua_transform = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_shapeshift_lua_transform:IsHidden()
    return true
end

function modifier_lycan_shapeshift_lua_transform:IsDebuff()
    return false
end

function modifier_lycan_shapeshift_lua_transform:IsPurgable()
    return false
end

function modifier_lycan_shapeshift_lua_transform:RemoveOnDeath()
    return true
end

function modifier_lycan_shapeshift_lua_transform:OnCreated()
    if not IsServer() then
        return
    end

    self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end

function modifier_lycan_shapeshift_lua_transform:OnDestroy()
    if not IsServer() then
        return
    end

    local caster = self:GetAbility():GetCaster()
    local shapeshift_duration = self:GetAbility():GetSpecialValueFor("duration") + caster:GetStrength() * self:GetAbility():GetSpecialValueFor("duration_increase_per_strength")
    caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
    caster:AddNewModifier(
            caster, -- player source
            self:GetAbility(), -- ability source
            "modifier_lycan_shapeshift_lua", -- modifier name
            { duration = shapeshift_duration } -- kv
    )
end

--------------------------------------------------------------------------------
function modifier_lycan_shapeshift_lua_transform:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end