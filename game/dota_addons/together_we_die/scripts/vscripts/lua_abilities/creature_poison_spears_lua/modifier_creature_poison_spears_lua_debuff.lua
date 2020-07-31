modifier_creature_poison_spears_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_poison_spears_lua_debuff:IsHidden()
    return false
end

function modifier_creature_poison_spears_lua_debuff:IsDebuff()
    return true
end

function modifier_creature_poison_spears_lua_debuff:IsStunDebuff()
    return false
end

function modifier_creature_poison_spears_lua_debuff:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_poison_spears_lua_debuff:OnCreated(kv)
    -- references
    self.slow_attack_speed = self:GetAbility():GetSpecialValueFor("slow_attack_speed") -- special value
    self.slow_move_speed = self:GetAbility():GetSpecialValueFor("slow_move_speed") -- special value
    self.dps = self:GetAbility():GetSpecialValueFor("dps") -- special value
    self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval") -- special value

    if IsServer() then
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = math.floor(self.tick_interval * self.dps),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }
        -- Start interval
        self:StartIntervalThink(self.tick_interval)
    end
end

function modifier_creature_poison_spears_lua_debuff:OnRefresh(kv)
    -- references
    self:OnCreated(kv)
end

function modifier_creature_poison_spears_lua_debuff:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_creature_poison_spears_lua_debuff:OnIntervalThink()
    -- Apply damage
    ApplyDamage(self.damageTable)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_poison_spears_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_creature_poison_spears_lua_debuff:GetModifierAttackSpeedBonus_Constant()
    return self.slow_attack_speed
end

function modifier_creature_poison_spears_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.slow_move_speed
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_poison_spears_lua_debuff:GetEffectName()
    return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

function modifier_creature_poison_spears_lua_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end