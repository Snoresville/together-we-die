modifier_creature_slark_shadow_dance_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_shadow_dance_lua_thinker:IsHidden()
    return true
end

function modifier_creature_slark_shadow_dance_lua_thinker:IsDebuff()
    return false
end

function modifier_creature_slark_shadow_dance_lua_thinker:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_shadow_dance_lua_thinker:OnCreated(kv)
    if IsServer() then
        self:PlayEffects()

        -- Start interval
        self:StartIntervalThink(FrameTime())
        self:OnIntervalThink()
    end
end

function modifier_creature_slark_shadow_dance_lua_thinker:OnRefresh(kv)
end

function modifier_creature_slark_shadow_dance_lua_thinker:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_creature_slark_shadow_dance_lua_thinker:OnIntervalThink()
    if self:GetCaster() and self:GetCaster() ~= nil then
        self:GetParent():SetOrigin(self:GetCaster():GetAbsOrigin())
    else
        self:GetParent():ForceKill(false)
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_slark_shadow_dance_lua_thinker:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(effect_cast, false, false, 15, false, false)
end