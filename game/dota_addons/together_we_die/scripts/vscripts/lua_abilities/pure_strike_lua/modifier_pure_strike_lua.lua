modifier_pure_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pure_strike_lua:IsHidden()
	return true
end

function modifier_pure_strike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_pure_strike_lua:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.pri_attr_multiplier = self:GetAbility():GetSpecialValueFor( "pri_attr_multiplier" )
end

function modifier_pure_strike_lua:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.pri_attr_multiplier = self:GetAbility():GetSpecialValueFor( "pri_attr_multiplier" )
end

function modifier_pure_strike_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_pure_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}

	return funcs
end

function modifier_pure_strike_lua:GetModifierProcAttack_BonusDamage_Pure( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) and self:GetAbility():IsCooldownReady() then
		if self:RollChance( self.crit_chance ) then
			local damage_bonus = math.floor(self.pri_attr_multiplier * self:GetParent():GetPrimaryStatValue())
			self.record = params.record
			-- cooldown
			self:GetAbility():UseResources( false, false, true )
			return damage_bonus
		end
	end
end

function modifier_pure_strike_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_pure_strike_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_pure_strike_lua:PlayEffects( target )
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