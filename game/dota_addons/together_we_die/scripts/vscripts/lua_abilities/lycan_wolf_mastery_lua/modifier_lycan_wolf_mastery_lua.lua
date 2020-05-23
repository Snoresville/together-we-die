modifier_lycan_wolf_mastery_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_wolf_mastery_lua:IsHidden()
	return false
end

function modifier_lycan_wolf_mastery_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lycan_wolf_mastery_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end

-- Evasion
function modifier_lycan_wolf_mastery_lua:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor( "evasion" )
end

-- Lifesteal
function modifier_lycan_wolf_mastery_lua:OnAttackLanded()
	local heal = params.damage * (self.aura_lifesteal + math.floor(self:GetCaster():GetStrength() * self.str_multiplier))/100
	self:GetParent():Heal( heal, self:GetAbility() )
	self:LifestealEffect()
end

function modifier_lycan_wolf_mastery_lua:LifestealEffect()
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-- Base Attack Time Decrease
function modifier_lycan_wolf_mastery_lua:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor( "bat_decrease" )
end

-- Critical Strike
function modifier_lycan_wolf_mastery_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and math.random() < self:GetAbility():GetSpecialValueFor( "crit_chance" ) then
	self:CriticalEffect()
		return self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	end
end

function modifier_lycan_wolf_mastery_lua:CriticalEffect()
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_brewmaster/brewmaster_drunken_brawler_crit.vpcf"
	local sound_cast = "Hero_Brewmaster.Brawler.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Make some noise
	EmitSoundOn(sound_cast, self:GetCaster())
end