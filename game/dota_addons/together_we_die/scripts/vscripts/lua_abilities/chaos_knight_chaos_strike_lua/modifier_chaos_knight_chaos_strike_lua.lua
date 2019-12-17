modifier_chaos_knight_chaos_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaos_knight_chaos_strike_lua:IsHidden()
	return true
end

function modifier_chaos_knight_chaos_strike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaos_knight_chaos_strike_lua:OnCreated( kv )
	-- references
	self.min_str_multiplier = self:GetAbility():GetSpecialValueFor( "min_str_multiplier" )
	self.max_str_multiplier = self:GetAbility():GetSpecialValueFor( "max_str_multiplier" )
	self.crit_min = self:GetAbility():GetSpecialValueFor( "crit_min" )
	self.crit_max = self:GetAbility():GetSpecialValueFor( "crit_max" )
	self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal" )
end

function modifier_chaos_knight_chaos_strike_lua:OnRefresh( kv )
	-- references
	self.min_str_multiplier = self:GetAbility():GetSpecialValueFor( "min_str_multiplier" )
	self.max_str_multiplier = self:GetAbility():GetSpecialValueFor( "max_str_multiplier" )
	self.crit_min = self:GetAbility():GetSpecialValueFor( "crit_min" )
	self.crit_max = self:GetAbility():GetSpecialValueFor( "crit_max" )
	self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal" )
end

function modifier_chaos_knight_chaos_strike_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_chaos_knight_chaos_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_chaos_knight_chaos_strike_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) and self:GetAbility():IsFullyCastable() then
		self.record = params.record
		-- cooldown
		self:GetAbility():UseResources( false, false, true )
		local caster_strength = self:GetParent():GetStrength()
		local crit_min = self.crit_min + caster_strength * self.min_str_multiplier
		local crit_max = self.crit_max + caster_strength * self.max_str_multiplier
		local crit = self:Expand(math.random(),crit_min,crit_max)
		return crit
	end
end

function modifier_chaos_knight_chaos_strike_lua:OnTakeDamage( params )
	if IsServer() then
		-- filter
		local pass = false
		if self.record and params.record == self.record then
			pass = true
			self.record = nil
		end

		-- logic
		if pass then
			-- get heal value
			local heal = params.damage * self.lifesteal/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_chaos_knight_chaos_strike_lua:Expand( value, min, max )
	return (max-min)*value + min
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_chaos_knight_chaos_strike_lua:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	local sound_cast = "Hero_ChaosKnight.ChaosStrike"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end