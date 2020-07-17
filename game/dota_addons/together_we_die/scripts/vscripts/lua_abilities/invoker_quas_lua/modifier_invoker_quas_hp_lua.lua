modifier_invoker_quas_hp_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_quas_hp_lua:IsHidden()
    return true
end

function modifier_invoker_quas_hp_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_quas_hp_lua:OnCreated(kv)
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

function modifier_invoker_quas_hp_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_invoker_quas_hp_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_invoker_quas_hp_lua:OnIntervalThink()
    -- Talent Tree
    local special_quas_hp_lua = self:GetParent():FindAbilityByName("special_quas_hp_lua")
    if special_quas_hp_lua and special_quas_hp_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)
    end
end