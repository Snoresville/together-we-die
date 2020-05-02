modifier_riki_permanent_invisibility_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_permanent_invisibility_lua:IsHidden()
    return false
end

function modifier_riki_permanent_invisibility_lua:IsDebuff()
    return false
end

function modifier_riki_permanent_invisibility_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_permanent_invisibility_lua:OnCreated(kv)
    if self:GetAbility():GetLevel() ~= 0 then
        -- references
        self.reactivation_time = self:GetAbility():GetSpecialValueFor("reactivation_time")
        self.ability_reveal = self:GetAbility():GetSpecialValueFor("ability_reveal")
        self.attack_reveal = self:GetAbility():GetSpecialValueFor("attack_reveal")

        if IsServer() then
            -- Start interval
            self:StartIntervalThink(self.reactivation_time)
        end
    end
end

function modifier_riki_permanent_invisibility_lua:OnRefresh(kv)
    -- references
    self.reactivation_time = self:GetAbility():GetSpecialValueFor("reactivation_time")
    self.ability_reveal = self:GetAbility():GetSpecialValueFor("ability_reveal")
    self.attack_reveal = self:GetAbility():GetSpecialValueFor("attack_reveal")

    if IsServer() then
        -- Start interval
        self:StartIntervalThink(self.reactivation_time)
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_riki_permanent_invisibility_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK,
    }

    return funcs
end

function modifier_riki_permanent_invisibility_lua:OnAbilityExecuted(params)
    if IsServer() then
        if not self.ability_reveal then
            return
        end
        if params.unit ~= self:GetParent() then
            return
        end

        if IsServer() then
            -- Start interval
            self:StartIntervalThink(self.reactivation_time)
        end
    end
end

function modifier_riki_permanent_invisibility_lua:OnAttack(params)
    if IsServer() then
        if not self.attack_reveal then
            return
        end
        if params.attacker ~= self:GetParent() then
            return
        end

        if IsServer() then
            -- Start interval
            self:StartIntervalThink(self.reactivation_time)
        end
    end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_riki_permanent_invisibility_lua:OnIntervalThink()
    -- Stop the interval
    self:StartIntervalThink(-1)

    -- Grant invisibility buff
    self:GetParent():AddNewModifier(
            self:GetParent(),
            self:GetAbility(),
            "modifier_riki_permanent_invisibility_lua_buff",
            {}
    )
end