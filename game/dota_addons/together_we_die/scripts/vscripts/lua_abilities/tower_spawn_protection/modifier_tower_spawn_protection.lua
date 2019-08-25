modifier_tower_spawn_protection = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tower_spawn_protection:IsHidden()
	return true
end

function modifier_tower_spawn_protection:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tower_spawn_protection:OnCreated( kv )
	-- references
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
end

function modifier_tower_spawn_protection:OnRefresh( kv )
	-- references
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
end

function modifier_tower_spawn_protection:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tower_spawn_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_tower_spawn_protection:GetModifierProcAttack_BonusDamage_Pure( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) and self:GetAbility():IsCooldownReady() then
		local damage_bonus = self:GetParent():GetAverageTrueAttackDamage( params.target ) * self.multiplier
		self.record = params.record
		-- cooldown
		self:GetAbility():UseResources( false, false, true )
		return damage_bonus
	end
end

function modifier_tower_spawn_protection:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetModifierIncomingDamage_Percentage( params )
	if IsServer() then
		return -100
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tower_spawn_protection:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end