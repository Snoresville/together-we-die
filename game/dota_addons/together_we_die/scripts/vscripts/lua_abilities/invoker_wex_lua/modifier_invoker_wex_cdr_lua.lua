modifier_invoker_wex_cdr_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_wex_cdr_lua:IsHidden()
    return true
end

function modifier_invoker_wex_cdr_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_wex_cdr_lua:OnCreated(kv)
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

function modifier_invoker_wex_cdr_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_invoker_wex_cdr_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_invoker_wex_cdr_lua:OnIntervalThink()
    -- Talent Tree
    local special_wex_cdr_lua = self:GetParent():FindAbilityByName("special_wex_cdr_lua")
    if special_wex_cdr_lua and special_wex_cdr_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)
    end
end