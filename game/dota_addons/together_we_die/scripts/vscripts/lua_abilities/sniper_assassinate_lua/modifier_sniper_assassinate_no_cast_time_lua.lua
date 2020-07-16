modifier_sniper_assassinate_no_cast_time_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_assassinate_no_cast_time_lua:IsHidden()
    return true
end

function modifier_sniper_assassinate_no_cast_time_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_assassinate_no_cast_time_lua:OnCreated(kv)
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

function modifier_sniper_assassinate_no_cast_time_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_sniper_assassinate_no_cast_time_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_assassinate_no_cast_time_lua:OnIntervalThink()
    -- Talent Tree
    local special_assassinate_cast_time_lua = self:GetParent():FindAbilityByName("special_assassinate_cast_time_lua")
    if special_assassinate_cast_time_lua and special_assassinate_cast_time_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)
    end
end