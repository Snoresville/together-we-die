modifier_drow_ranger_mind_break_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_mind_break_lua:IsHidden()
    return true
end

function modifier_drow_ranger_mind_break_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drow_ranger_mind_break_lua:OnCreated(kv)
    -- references
    self.proc_chance = self:GetAbility():GetSpecialValueFor("proc_chance") -- special value
    self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration") -- special value
    self.knockback_duration = self:GetAbility():GetSpecialValueFor("knockback_duration") -- special value
    self.knockback_distance = self:GetAbility():GetSpecialValueFor("knockback_distance")
    self.knockback_agi_multiplier = self:GetAbility():GetSpecialValueFor("knockback_agi_multiplier")
    self.parent = self:GetParent()
end

function modifier_drow_ranger_mind_break_lua:OnRefresh(kv)
    -- references
    self.proc_chance = self:GetAbility():GetSpecialValueFor("proc_chance") -- special value
    self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration") -- special value
    self.knockback_duration = self:GetAbility():GetSpecialValueFor("knockback_duration") -- special value
    self.knockback_distance = self:GetAbility():GetSpecialValueFor("knockback_distance")
    self.knockback_agi_multiplier = self:GetAbility():GetSpecialValueFor("knockback_agi_multiplier")
    self.parent = self:GetParent()
end

function modifier_drow_ranger_mind_break_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_mind_break_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
    }

    return funcs
end

function modifier_drow_ranger_mind_break_lua:OnAttack(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self.parent then
        return
    end

    -- not proc for attacking allies
    if params.target:GetTeamNumber() == params.attacker:GetTeamNumber() then
        return
    end

    -- not proc if break
    if self.parent:PassivesDisabled() then
        return
    end

    -- not proc if on cooldown
    if not self:GetAbility():IsFullyCastable() then
        return
    end

    -- not proc if attack can't use attack modifiers
    --if not params.process_procs then return end

    -- roll dice
    if RandomInt(1, 100) <= self.proc_chance then
        local attackerAgility = self.parent:GetAgility()
        params.target:AddNewModifier(
                self:GetParent(), -- player source
                self, -- ability source
                "modifier_generic_silenced_lua", -- modifier name
                {
                    duration = self.silence_duration,
                } -- kv
        )

        local enemyOrigin = params.target:GetOrigin()
        local attackerOrigin = self.parent:GetOrigin()

        -- knockback
        params.target:AddNewModifier(
                self.parent, -- player source
                self, -- ability source
                "modifier_generic_knockback_lua", -- modifier name
                {
                    duration = self.knockback_duration,
                    distance = self.knockback_distance + (attackerAgility * self.knockback_agi_multiplier),
                    height = 30,
                    direction_x = enemyOrigin.x - attackerOrigin.x,
                    direction_y = enemyOrigin.y - attackerOrigin.y,
                } -- kv
        )

        -- cooldown
        self:GetAbility():UseResources(false, false, true)
    end
end