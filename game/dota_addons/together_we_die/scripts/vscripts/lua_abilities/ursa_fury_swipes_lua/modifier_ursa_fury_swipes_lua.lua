modifier_ursa_fury_swipes_lua = class({})

--------------------------------------------------------------------------------

function modifier_ursa_fury_swipes_lua:IsHidden()
    return true
end

function modifier_ursa_fury_swipes_lua:IsDebuff()
    return false
end

function modifier_ursa_fury_swipes_lua:IsPurgable()
    return false
end
--------------------------------------------------------------------------------

function modifier_ursa_fury_swipes_lua:OnCreated(kv)
    if IsServer() then
        -- get reference
        self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
        self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
        self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
    end
end

function modifier_ursa_fury_swipes_lua:OnRefresh(kv)
    if IsServer() then
        -- get reference
        self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
        self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
        self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
    end
end
--------------------------------------------------------------------------------

function modifier_ursa_fury_swipes_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_ursa_fury_swipes_lua:GetModifierProcAttack_BonusDamage_Physical(params)
    if IsServer() then
        if self:GetParent():PassivesDisabled() then
            return
        end
        -- get target
        local target = params.target
        if target == nil then
            target = params.unit
        end

        -- get modifier stack
        local stack = 0
        local modifierStack
        if target:HasModifier("modifier_ursa_fury_swipes_debuff_lua") then
            modifierStack = target:FindModifierByName("modifier_ursa_fury_swipes_debuff_lua")
            modifierStack:IncrementStackCount()
            modifierStack:ForceRefresh()
        else
            -- add stack modifier
            modifierStack = target:AddNewModifier(
                    self:GetParent(),
                    self:GetAbility(),
                    "modifier_ursa_fury_swipes_debuff_lua",
                    { duration = self.bonus_reset_time }
            )
        end

        -- get stack number
        stack = modifierStack:GetStackCount()

        self:PlayEffects(target)

        -- return damage bonus
        return stack * (self.damage_per_stack + self:GetCaster():GetAgility() * self.agi_multiplier)
    end
end

function modifier_ursa_fury_swipes_lua:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"

    -- Play hit particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)
end