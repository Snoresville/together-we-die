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
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    -- Talent tree
    local special_frost_arrow_movement_lua = caster:FindAbilityByName( "special_frost_arrow_movement_lua" )
    if ( special_frost_arrow_movement_lua and special_frost_arrow_movement_lua:GetLevel() ~= 0 ) then
        self.slow = self.slow + special_frost_arrow_movement_lua:GetSpecialValueFor( "value" )
    end
    -- Talent tree
    local special_frost_arrow_agi_multiplier_lua = caster:FindAbilityByName( "special_frost_arrow_agi_multiplier_lua" )
    if ( special_frost_arrow_agi_multiplier_lua and special_frost_arrow_agi_multiplier_lua:GetLevel() ~= 0 ) then
        self.agi_multiplier = self.agi_multiplier + special_frost_arrow_agi_multiplier_lua:GetSpecialValueFor( "value" )
    end
    local damage = caster:GetAgility() * self.agi_multiplier
    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }

    local interval = self.frost_arrows_bite_interval
    local special_frost_arrow_bite_interval_lua = caster:FindAbilityByName("special_frost_arrow_bite_interval_lua")
    if (special_frost_arrow_bite_interval_lua and special_frost_arrow_bite_interval_lua:GetLevel() ~= 0) then
        interval = interval + special_frost_arrow_bite_interval_lua:GetSpecialValueFor("value")
    end
    -- Start interval
    self:StartIntervalThink(interval)
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