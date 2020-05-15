modifier_abaddon_frostmourne_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_frostmourne_lua_debuff:IsHidden()
    return false
end

function modifier_abaddon_frostmourne_lua_debuff:IsPurgable()
    return true
end

function modifier_abaddon_frostmourne_lua_debuff:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_frostmourne_lua_debuff:OnCreated(kv)
    -- references
    self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
    self.curse_duration = self:GetAbility():GetSpecialValueFor("curse_duration")
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")

    if not IsServer() then
        return
    end
    self:PlayEffects()
end

function modifier_abaddon_frostmourne_lua_debuff:OnRefresh(kv)
    -- references
    self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
    self.curse_duration = self:GetAbility():GetSpecialValueFor("curse_duration")
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

function modifier_abaddon_frostmourne_lua_debuff:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_abaddon_frostmourne_lua_debuff:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_frostmourne_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_abaddon_frostmourne_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.curse_slow
end

function modifier_abaddon_frostmourne_lua_debuff:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    if params.target ~= self:GetParent() then
        return
    end

    -- apply damage
    local damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self:GetCaster():GetStrength() * self.str_multiplier,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }
    ApplyDamage(damageTable)

    -- Apply buff to attacker
    params.attacker:AddNewModifier(
            self:GetCaster(),
            self:GetAbility(),
            "modifier_abaddon_frostmourne_lua_buff",
            { duration = self.curse_duration }
    )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_abaddon_frostmourne_lua_debuff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end

function modifier_abaddon_frostmourne_lua_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_abaddon_frostmourne_lua_debuff:PlayEffects()
    local particle_cast = "particles/generic_gameplay/generic_silenced.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    self:AddParticle(
            effect_cast,
            false,
            true,
            -1,
            false,
            true
    )
end