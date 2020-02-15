modifier_lifestealer_feast_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lifestealer_feast_lua:IsHidden()
    return true
end

function modifier_lifestealer_feast_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lifestealer_feast_lua:OnCreated(kv)
    -- references
    self.leech_percent = self:GetAbility():GetSpecialValueFor("hp_leech_percent") / 100 -- special value
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

function modifier_lifestealer_feast_lua:OnRefresh(kv)
    -- references
    self.leech_percent = self:GetAbility():GetSpecialValueFor("hp_leech_percent") / 100 -- special value
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

function modifier_lifestealer_feast_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lifestealer_feast_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    }

    return funcs
end

function modifier_lifestealer_feast_lua:GetModifierProcAttack_BonusDamage_Physical(params)
    if IsServer() then
        if self:GetParent():PassivesDisabled() then
            return
        end

        -- leech
		local strength_heal_pct = self:GetParent():GetStrength() * self.str_multiplier
        local leech = params.target:GetHealth() * (self.leech_percent + strength_heal_pct)
        self:GetParent():Heal(leech, self:GetParent())
        self:PlayEffects()
        return leech
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_lifestealer_feast_lua:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_lifestealer_feast_lua:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_lifestealer_feast_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    -- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
    -- ParticleManager:SetParticleControlEnt(
    -- 	effect_cast,
    -- 	iControlPoint,
    -- 	hTarget,
    -- 	PATTACH_NAME,
    -- 	"attach_name",
    -- 	vOrigin, -- unknown
    -- 	bool -- unknown, true
    -- )
    ParticleManager:ReleaseParticleIndex(effect_cast)
end