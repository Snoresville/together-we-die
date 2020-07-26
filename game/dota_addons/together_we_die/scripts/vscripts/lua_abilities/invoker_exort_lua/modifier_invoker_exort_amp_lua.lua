modifier_invoker_exort_amp_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_exort_amp_lua:IsHidden()
    return true
end

function modifier_invoker_exort_amp_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_exort_amp_lua:OnCreated(kv)
    self:SetStackCount(0)
    -- use stack system
    if not IsServer() then
        return
    end
    -- start interval
    self:OnIntervalThink()
    local interval = 1
    self:StartIntervalThink(interval)
end

function modifier_invoker_exort_amp_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_invoker_exort_amp_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_invoker_exort_amp_lua:OnIntervalThink()
    -- Talent Tree
    local special_exort_amp_lua = self:GetParent():FindAbilityByName("special_exort_amp_lua")
    if special_exort_amp_lua and special_exort_amp_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)
    end
end