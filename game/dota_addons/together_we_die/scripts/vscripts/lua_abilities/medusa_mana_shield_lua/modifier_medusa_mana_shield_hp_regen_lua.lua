modifier_medusa_mana_shield_hp_regen_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mana_shield_hp_regen_lua:IsHidden()
    return true
end

function modifier_medusa_mana_shield_hp_regen_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_medusa_mana_shield_hp_regen_lua:OnCreated(kv)
    self:SetStackCount(0)
    -- use stack system
    if not IsServer() then
        return
    end
    -- start interval
    self:OnIntervalThink()
    local interval = 1.0
    self:StartIntervalThink(interval)
end

function modifier_medusa_mana_shield_hp_regen_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_medusa_mana_shield_hp_regen_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_medusa_mana_shield_hp_regen_lua:OnIntervalThink()
    -- Talent Tree
    local special_mana_shield_hp_regen_lua = self:GetParent():FindAbilityByName("special_mana_shield_hp_regen_lua")
    if special_mana_shield_hp_regen_lua and special_mana_shield_hp_regen_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)
    end
end