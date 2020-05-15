modifier_abaddon_frostmourne_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_frostmourne_lua_stack:IsHidden()
    return false
end

function modifier_abaddon_frostmourne_lua_stack:IsPurgable()
    return true
end

function modifier_abaddon_frostmourne_lua_stack:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_frostmourne_lua_stack:OnCreated(kv)
    self:SetStackCount(1)
    -- references
    self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed")

    if not IsServer() then
        return
    end
    self:PlayEffects()
end

function modifier_abaddon_frostmourne_lua_stack:OnRefresh(kv)
    -- references
    self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed")

    if not IsServer() then
        return
    end
    self:PlayEffects()
end

function modifier_abaddon_frostmourne_lua_stack:OnDestroy(kv)
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_frostmourne_lua_stack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_abaddon_frostmourne_lua_stack:GetModifierMoveSpeedBonus_Percentage()
    return -self.movement_speed
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_abaddon_frostmourne_lua_stack:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end

function modifier_abaddon_frostmourne_lua_stack:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_abaddon_frostmourne_lua_stack:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf"
    local counter = self:GetStackCount()

    -- Create Particle
    if self.effect_cast and self.effect_cast ~= nil then
        ParticleManager:DestroyParticle(self.effect_cast, false)
    end
    self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.effect_cast, 1, Vector(0, counter, 0))
    self:AddParticle(
            self.effect_cast,
            false,
            false,
            -1,
            false,
            true
    )
end