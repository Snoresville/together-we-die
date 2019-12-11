modifier_slark_shadow_dance_lua_passive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua_passive:IsHidden()
    return true
end

function modifier_slark_shadow_dance_lua_passive:IsDebuff()
    return false
end

function modifier_slark_shadow_dance_lua_passive:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua_passive:OnCreated(kv)
    -- references
    self.interval = self:GetAbility():GetSpecialValueFor("activation_delay") -- special value
    self.neutral_disable = self:GetAbility():GetSpecialValueFor("neutral_disable") -- special value
    self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen_pct") -- special value
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") -- special value
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.radius = 1800

    -- Start interval
    if not IsServer() then
        return
    end
    self:StartIntervalThink(self.interval)
    self:OnIntervalThink()
end

function modifier_slark_shadow_dance_lua_passive:OnRefresh(kv)
    -- references
    self.interval = self:GetAbility():GetSpecialValueFor("activation_delay") -- special value
    self.neutral_disable = self:GetAbility():GetSpecialValueFor("neutral_disable") -- special value
end

function modifier_slark_shadow_dance_lua_passive:OnDestroy(kv)
    if not IsServer() then return end
    if self:GetParent():HasModifier("modifier_slark_shadow_dance_lua_buff") then
        self:GetParent():RemoveModifierByNameAndCaster("modifier_slark_shadow_dance_lua_buff", self:GetCaster())
    end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_shadow_dance_lua_passive:OnIntervalThink()
    local parent = self:GetParent()
    -- find enemies
    local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(), -- int, your team number
            parent:GetOrigin(), -- point, center point
            parent, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_ALL, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )
    for _, enemy in pairs(enemies) do
        -- Can slark be seen by the enemy within the certain range
        if enemy:CanEntityBeSeenByMyTeam(parent) then
            -- Set to inactive and exit loop
            if self:GetParent():HasModifier("modifier_slark_shadow_dance_lua_buff") then
                self:GetParent():RemoveModifierByNameAndCaster("modifier_slark_shadow_dance_lua_buff", self:GetCaster())
            end
            return
        end
    end

    if not self:GetParent():HasModifier("modifier_slark_shadow_dance_lua_buff") then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_slark_shadow_dance_lua_buff", {})
    end
end