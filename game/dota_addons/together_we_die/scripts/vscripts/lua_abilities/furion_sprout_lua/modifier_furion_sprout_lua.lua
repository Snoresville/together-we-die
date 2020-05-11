modifier_furion_sprout_lua = class({})

--------------------------------------------------------------------------------

function modifier_furion_sprout_lua:IsDebuff()
    return true
end

function modifier_furion_sprout_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_furion_sprout_lua:OnCreated(kv)
    self.int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.interval = self:GetAbility():GetSpecialValueFor("interval")

    if IsServer() then
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = math.floor(self.interval * self.int_multiplier * self:GetCaster():GetIntellect()),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        self:StartIntervalThink(self.interval)
    end
end

function modifier_furion_sprout_lua:OnRefresh(kv)
    self:OnCreated(kv)
end

--------------------------------------------------------------------------------

function modifier_furion_sprout_lua:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_furion_sprout_lua:OnIntervalThink()
    ApplyDamage(self.damageTable)
end
--------------------------------------------------------------------------------

function modifier_furion_sprout_lua:GetEffectName()
    return "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle.vpcf"
end

function modifier_furion_sprout_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
