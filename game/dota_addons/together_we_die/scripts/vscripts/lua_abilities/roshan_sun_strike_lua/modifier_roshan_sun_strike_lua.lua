modifier_roshan_sun_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_sun_strike_lua:IsHidden()
    return self:GetParent():GetHealthPercent() > self.hp_percent
end

function modifier_roshan_sun_strike_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_sun_strike_lua:OnCreated(kv)
    -- references
    self.delay = self:GetAbility():GetSpecialValueFor("delay")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
    local interval = 1.0

    if IsServer() then
        self:StartIntervalThink(interval)
    end
end

function modifier_roshan_sun_strike_lua:OnRefresh(kv)
    -- references
    self.delay = self:GetAbility():GetSpecialValueFor("delay")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
end

function modifier_roshan_sun_strike_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_sun_strike_lua:OnIntervalThink()
    local modifierParent = self:GetParent()
    local selfAbility = self:GetAbility()
    local canCast = modifierParent:GetHealthPercent() <= self.hp_percent
    if modifierParent:IsAlive() and not modifierParent:PassivesDisabled() and canCast and selfAbility:IsFullyCastable() then
        local enemies = FindUnitsInRadius(
                modifierParent:GetTeamNumber(), -- int, your team number
                modifierParent:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                FIND_UNITS_EVERYWHERE, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
                self:GetAbility():GetAbilityTargetType(), -- int, type filter
                self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )

        for _, enemy in pairs(enemies) do
            local point = enemy:GetOrigin()
            CreateModifierThinker(
                    modifierParent,
                    selfAbility,
                    "modifier_roshan_sun_strike_lua_thinker",
                    { duration = self.delay },
                    point,
                    modifierParent:GetTeamNumber(),
                    false
            )
        end

        selfAbility:UseResources(false, false, true)
    end
end