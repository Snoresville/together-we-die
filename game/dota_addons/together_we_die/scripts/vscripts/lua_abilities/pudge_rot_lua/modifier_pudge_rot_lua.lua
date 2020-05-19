modifier_pudge_rot_lua = class({})
--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:IsDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:IsAura()
    if self:GetCaster() == self:GetParent() then
        return true
    end

    return false
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:GetModifierAura()
    return "modifier_pudge_rot_lua"
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:GetAuraRadius()
    return self.rot_radius
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:OnCreated(kv)
    self.rot_radius = self:GetAbility():GetSpecialValueFor("rot_radius")
    self.rot_slow = self:GetAbility():GetSpecialValueFor("rot_slow")
    self.rot_damage = self:GetAbility():GetSpecialValueFor("rot_damage")
    self.rot_tick = self:GetAbility():GetSpecialValueFor("rot_tick")
    self.self_damage_multiplier = self:GetAbility():GetSpecialValueFor("self_damage_multiplier")
    -- Talent Tree
    local special_rot_self_damage_multiplier_lua = self:GetCaster():FindAbilityByName("special_rot_self_damage_multiplier_lua")
    if special_rot_self_damage_multiplier_lua and special_rot_self_damage_multiplier_lua:GetLevel() ~= 0 then
        self.self_damage_multiplier = self.self_damage_multiplier + special_rot_self_damage_multiplier_lua:GetSpecialValueFor("value")
    end
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    -- Talent Tree
    local special_rot_str_multiplier_lua = self:GetCaster():FindAbilityByName("special_rot_str_multiplier_lua")
    if special_rot_str_multiplier_lua and special_rot_str_multiplier_lua:GetLevel() ~= 0 then
        self.str_multiplier = self.str_multiplier + special_rot_str_multiplier_lua:GetSpecialValueFor("value")
    end

    if IsServer() then
        if self:GetParent() == self:GetCaster() then
            EmitSoundOn("Hero_Pudge.Rot", self:GetCaster())
            local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.rot_radius, 1, self.rot_radius))
            self:AddParticle(nFXIndex, false, false, -1, false, false)
        else
            local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self:AddParticle(nFXIndex, false, false, -1, false, false)
        end

        self:StartIntervalThink(self.rot_tick)
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:OnDestroy()
    if IsServer() then
        StopSoundOn("Hero_Pudge.Rot", self:GetCaster())
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:GetModifierMoveSpeedBonus_Percentage(params)
    if self:GetParent() == self:GetCaster() then
        return 0
    end

    return self.rot_slow
end

--------------------------------------------------------------------------------

function modifier_pudge_rot_lua:OnIntervalThink()
    if IsServer() then
        local flDamagePerTick = self.rot_tick * (self.rot_damage + (self:GetCaster():GetStrength() * self.str_multiplier))

        if self:GetCaster():IsAlive() then
            local damage = {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage = flDamagePerTick,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility()
            }

            if self:GetParent() == self:GetCaster() then
                damage.damage_type = DAMAGE_TYPE_PURE
                damage.damage = flDamagePerTick * self.self_damage_multiplier
                damage.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
            end

            ApplyDamage(damage)
        end
    end
end
