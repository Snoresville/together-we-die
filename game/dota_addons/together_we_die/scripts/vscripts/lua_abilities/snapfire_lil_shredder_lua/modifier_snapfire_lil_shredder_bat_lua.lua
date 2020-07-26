modifier_snapfire_lil_shredder_bat_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_lil_shredder_bat_lua:IsHidden()
    return true
end

function modifier_snapfire_lil_shredder_bat_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_lil_shredder_bat_lua:OnCreated(kv)
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

function modifier_snapfire_lil_shredder_bat_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_snapfire_lil_shredder_bat_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_snapfire_lil_shredder_bat_lua:OnIntervalThink()
    -- Talent Tree
    local special_lil_shredder_bat_lua = self:GetParent():FindAbilityByName("special_lil_shredder_bat_lua")
    if special_lil_shredder_bat_lua and special_lil_shredder_bat_lua:GetLevel() ~= 0 then
        local bat = math.abs(special_lil_shredder_bat_lua:GetSpecialValueFor("value")) * 10
        self:SetStackCount(bat)
    end
end