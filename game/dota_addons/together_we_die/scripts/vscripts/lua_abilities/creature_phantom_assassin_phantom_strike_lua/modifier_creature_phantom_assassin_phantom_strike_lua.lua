modifier_creature_phantom_assassin_phantom_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_phantom_assassin_phantom_strike_lua:IsHidden()
    return false
end

function modifier_creature_phantom_assassin_phantom_strike_lua:IsDebuff()
    return false
end

function modifier_creature_phantom_assassin_phantom_strike_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_phantom_assassin_phantom_strike_lua:OnCreated(kv)
    -- references
    local attack_count = self:GetAbility():GetSpecialValueFor("bonus_max_attack_count") -- special value
    self.bat = self:GetAbility():GetSpecialValueFor("base_attack_time") -- special value

    -- Set Stack Count
    if IsServer() then
        self:SetStackCount(attack_count)
    end
end

function modifier_creature_phantom_assassin_phantom_strike_lua:OnRefresh(kv)
    local attack_count = self:GetAbility():GetSpecialValueFor("bonus_max_attack_count") -- special value
    self.bat = self:GetAbility():GetSpecialValueFor("base_attack_time") -- special value

    -- Set Stack Count
    if IsServer() then
        self:SetStackCount(attack_count)
    end
end

function modifier_creature_phantom_assassin_phantom_strike_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_phantom_assassin_phantom_strike_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_PROPERTY_PRE_ATTACK,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    }

    return funcs
end

function modifier_creature_phantom_assassin_phantom_strike_lua:GetModifierPreAttack(params)
    if IsServer() then
        -- Destroy if attacking invalid target
        local result = UnitFilter(
                params.target, -- Target Filter
                DOTA_UNIT_TARGET_TEAM_ENEMY, -- Team Filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, -- Unit Filter
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- Unit Flag
                self:GetParent():GetTeamNumber()    -- Team reference
        )

        if result ~= UF_SUCCESS then
            self:Destroy()
        end
    end
end
function modifier_creature_phantom_assassin_phantom_strike_lua:GetModifierProcAttack_Feedback(params)
    if IsServer() then
        self:DecrementStackCount()
        if self:GetStackCount() <= 0 then
            self:Destroy()
        end
    end
end
function modifier_creature_phantom_assassin_phantom_strike_lua:GetModifierBaseAttackTimeConstant()
    return self.bat
end