modifier_sniper_shrapnel_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_shrapnel_lua:IsHidden()
    return false
end

function modifier_sniper_shrapnel_lua:IsDebuff()
    return true
end

function modifier_sniper_shrapnel_lua:IsPurgable()
    return false
end

function modifier_sniper_shrapnel_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_shrapnel_lua:OnCreated(kv)
    -- references
    self.caster = self:GetCaster()
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.ms_slow = self:GetAbility():GetSpecialValueFor("slow_movement_speed") -- special value

    local interval = 1

    if IsServer() then
        -- Talent Tree
        local special_shrapnel_agi_multiplier_lua = self.caster:FindAbilityByName("special_shrapnel_agi_multiplier_lua")
        if special_shrapnel_agi_multiplier_lua and special_shrapnel_agi_multiplier_lua:GetLevel() ~= 0 then
            self.agi_multiplier = self.agi_multiplier + special_shrapnel_agi_multiplier_lua:GetSpecialValueFor("value")
        end
        self.damage = self:GetAbility():GetSpecialValueFor("shrapnel_damage") + (self.caster:GetAgility() * self.agi_multiplier) -- special value
        -- precache damage
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self.caster,
            damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        -- start interval
        self:StartIntervalThink(interval)
        self:OnIntervalThink()
    end
end

function modifier_sniper_shrapnel_lua:OnRefresh(kv)

end

function modifier_sniper_shrapnel_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_shrapnel_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end
function modifier_sniper_shrapnel_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_shrapnel_lua:OnIntervalThink()
    ApplyDamage(self.damageTable)
end