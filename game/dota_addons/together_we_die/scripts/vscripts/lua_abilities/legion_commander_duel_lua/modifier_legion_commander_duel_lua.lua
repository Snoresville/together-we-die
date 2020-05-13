modifier_legion_commander_duel_lua = class({})

--------------------------------------------------------------------------------
function modifier_legion_commander_duel_lua:IsHidden()
    return false
end

function modifier_legion_commander_duel_lua:IsDebuff()
    return false
end

function modifier_legion_commander_duel_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_legion_commander_duel_lua:OnCreated(kv)
    self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    if IsServer() then
        self:SetStackCount(self:GetAbility():GetDuelKills())
    end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_duel_lua:OnRefresh(kv)
    self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_duel_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_legion_commander_duel_lua:OnDeath(event)
    if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() then
        return
    end

    if event.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() and event.attacker == self:GetParent() then
        self:GetAbility():IncrementDuelKills()

        self:SetStackCount(self:GetAbility():GetDuelKills())

        local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1, 0, 0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_duel_lua:GetModifierPreAttack_BonusDamage(params)
    if not self:GetParent():PassivesDisabled() then
        return self:GetStackCount() * self.damage_bonus + self:GetStackCount() * self.str_multiplier * self:GetParent():GetStrength()
    end

    return 0
end

--------------------------------------------------------------------------------