modifier_abaddon_borrow_time_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_borrow_time_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_abaddon_borrow_time_lua:OnCreated(kv)
    self.threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
end

function modifier_abaddon_borrow_time_lua:OnRefresh(kv)
    self.threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
end

--------------------------------------------------------------------------------

function modifier_abaddon_borrow_time_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_abaddon_borrow_time_lua:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end
    if self:GetParent():PassivesDisabled() then
        return
    end
    -- not proc if on cooldown
    if not self:GetAbility():IsFullyCastable() then
        return
    end

    if self:GetParent():GetHealth() < self.threshold then
        -- automatically cast it when below threshold
        self:GetAbility():CastAbility()
    end
end