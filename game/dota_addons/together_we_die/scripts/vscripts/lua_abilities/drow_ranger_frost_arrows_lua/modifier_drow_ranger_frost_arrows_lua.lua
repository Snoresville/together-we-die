modifier_drow_ranger_frost_arrows_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_frost_arrows_lua:IsHidden()
    return false
end

function modifier_drow_ranger_frost_arrows_lua:IsDebuff()
    return true
end

function modifier_drow_ranger_frost_arrows_lua:IsStunDebuff()
    return false
end

function modifier_drow_ranger_frost_arrows_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drow_ranger_frost_arrows_lua:OnCreated(kv)
    -- references
    self.slow = self:GetAbility():GetSpecialValueFor("frost_arrows_movement_speed")
    self.frost_arrows_bite_interval = self:GetAbility():GetSpecialValueFor("frost_arrows_bite_interval")
    if not IsServer() then
        return
    end
    local damage = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agi_multiplier")
    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self, --Optional.
    }

    -- Start interval
    self:StartIntervalThink(self.frost_arrows_bite_interval)
end

function modifier_drow_ranger_frost_arrows_lua:OnRefresh(kv)
    self:OnCreated(kv)
end

function modifier_drow_ranger_frost_arrows_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_drow_ranger_frost_arrows_lua:OnIntervalThink()
    -- apply damage
    ApplyDamage(self.damageTable)
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_frost_arrows_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end
function modifier_drow_ranger_frost_arrows_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_drow_ranger_frost_arrows_lua:GetEffectName()
    return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_drow_ranger_frost_arrows_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end