modifier_sven_great_cleave_lua = class({})

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnCreated(kv)
    self.great_cleave_damage = self:GetAbility():GetSpecialValueFor("great_cleave_damage")
    self.starting_width = self:GetAbility():GetSpecialValueFor("starting_width")
    self.ending_width = self:GetAbility():GetSpecialValueFor("ending_width")
    self.distance = self:GetAbility():GetSpecialValueFor("distance")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.damage_str_multiplier = self:GetAbility():GetSpecialValueFor("damage_str_multiplier")
    self.cleave_str_multiplier = self:GetAbility():GetSpecialValueFor("cleave_str_multiplier")
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnRefresh(kv)
    self.great_cleave_damage = self:GetAbility():GetSpecialValueFor("great_cleave_damage")
    self.starting_width = self:GetAbility():GetSpecialValueFor("starting_width")
    self.ending_width = self:GetAbility():GetSpecialValueFor("ending_width")
    self.distance = self:GetAbility():GetSpecialValueFor("distance")
    self.damage_str_multiplier = self:GetAbility():GetSpecialValueFor("damage_str_multiplier")
    self.cleave_str_multiplier = self:GetAbility():GetSpecialValueFor("cleave_str_multiplier")
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnAttackLanded(params)
    if IsServer() then
        if params.attacker == self:GetParent() then
            if self:GetParent():PassivesDisabled() then
                return 0
            end

            local target = params.target
            if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                local cleaveDamage = (self.great_cleave_damage * params.damage) / 100.0
                local cleaveDistance = self.distance + math.floor(self:GetParent():GetStrength() * self.cleave_str_multiplier)
                DoCleaveAttack(self:GetParent(), target, self:GetAbility(), cleaveDamage, self.starting_width, self.ending_width, cleaveDistance, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf")
            end
        end
    end

    return 0
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:GetModifierPreAttack_BonusDamage(params)
    if not self:GetParent():PassivesDisabled() then
        return self.bonus_damage + math.floor(self:GetParent():GetStrength() * self.damage_str_multiplier)
    end

    return 0
end
