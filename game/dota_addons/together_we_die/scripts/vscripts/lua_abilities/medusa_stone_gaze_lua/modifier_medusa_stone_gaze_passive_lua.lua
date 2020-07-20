modifier_medusa_stone_gaze_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_stone_gaze_passive_lua:IsHidden()
    return true
end

function modifier_medusa_stone_gaze_passive_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_medusa_stone_gaze_passive_lua:OnCreated(kv)
    self:SetStackCount(0)
    -- use stack system
    if not IsServer() then
        return
    end
    -- start interval
    self:OnIntervalThink()
    local interval = 0.5
    self:StartIntervalThink(interval)
end

function modifier_medusa_stone_gaze_passive_lua:OnRefresh(kv)
    -- use stack system
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
end

function modifier_medusa_stone_gaze_passive_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_medusa_stone_gaze_passive_lua:OnIntervalThink()
    -- Talent Tree
    local special_stone_gaze_passive_lua = self:GetParent():FindAbilityByName("special_stone_gaze_passive_lua")
    if special_stone_gaze_passive_lua and special_stone_gaze_passive_lua:GetLevel() ~= 0 then
        self:SetStackCount(1)

        if not self:GetParent():PassivesDisabled() then
            -- create modifier
            self:GetParent():AddNewModifier(
                    self:GetParent(), -- player source
                    self:GetAbility(), -- ability source
                    "modifier_medusa_stone_gaze_lua", -- modifier name
                    {} -- kv
            )
        else
            self:GetParent():RemoveModifierByName("modifier_medusa_stone_gaze_lua");
        end
    end
end