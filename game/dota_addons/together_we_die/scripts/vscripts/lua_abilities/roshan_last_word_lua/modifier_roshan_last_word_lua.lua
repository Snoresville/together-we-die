--------------------------------------------------------------------------------
modifier_roshan_last_word_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_last_word_lua:IsHidden()
    return true
end

function modifier_roshan_last_word_lua:IsDebuff()
    return false
end

function modifier_roshan_last_word_lua:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------
function modifier_roshan_last_word_lua:OnCreated(kv)
    self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration")
    self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
end

--------------------------------------------------------------------------------

function modifier_roshan_last_word_lua:OnRefresh(kv)
    self:OnCreated(kv)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_last_word_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }

    return funcs
end

function modifier_roshan_last_word_lua:OnAbilityFullyCast(params)
    -- Hp must be below threshold
    if self:GetParent():GetHealthPercent() > self.hp_percent then
        return
    end
    -- Does not affect self
    if params.unit == self:GetParent() then
        return
    end
    -- Does not affect own team
    if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
        return
    end

    -- Ensure it is not a passive ability
    if bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE) ~= 0 then
        return
    end

    -- Stun caster
    params.unit:AddNewModifier(
            self:GetParent(), -- player source
            self:GetAbility(), -- ability source
            "modifier_generic_stunned_lua", -- modifier name
            {
                duration = self.stun_duration
            } -- kv
    )

    -- Silence all enemies
    local targets = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), -- int, your team number
            self:GetParent():GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
            self:GetAbility():GetAbilityTargetType(), -- int, type filter
            self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )
    for _, enemy in pairs(targets) do
        enemy:AddNewModifier(
                self:GetParent(), -- player source
                self:GetAbility(), -- ability source
                "modifier_generic_silenced_lua", -- modifier name
                {
                    duration = self.silence_duration
                } -- kv
        )
    end
end