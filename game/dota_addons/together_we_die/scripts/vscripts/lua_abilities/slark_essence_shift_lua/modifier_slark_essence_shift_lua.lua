modifier_slark_essence_shift_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua:IsHidden()
	return true
end

function modifier_slark_essence_shift_lua:IsDebuff()
	return false
end

function modifier_slark_essence_shift_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.permanent_agi_gain_modifier_name = "modifier_slark_essence_shift_lua_gain"
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_slark_essence_shift_lua:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if IsServer() then
		local permanent_agi_gain_modifier = self:GetParent():FindModifierByName( self.permanent_agi_gain_modifier_name )
		if permanent_agi_gain_modifier then
			permanent_agi_gain_modifier:ForceRefresh()
		end
	end
end

function modifier_slark_essence_shift_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_slark_essence_shift_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		-- filter enemy
		local target = params.target
		-- Make sure attacker isn't illusion AND that the target isn't a building
		if self:GetParent():IsIllusion() or target:IsBuilding() then
			return
		end

		-- Apply debuff to enemy
		params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_slark_essence_shift_lua_debuff",
			{
				duration = self.duration,
			}
		)

		-- Apply buff to self
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_slark_essence_shift_lua_stack",
			{
				duration = self.duration,
			}
		)

		-- Play effects
		self:PlayEffects( params.target )
	end
end

function modifier_slark_essence_shift_lua:OnDeath( event )
	if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() or event.unit:IsIllusion() then
		return
	end

	if event.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsAlive() and event.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
		if event.unit:IsRealHero() then
			self:GetAbility():IncrementHeroKills()
		else
			self:GetAbility():IncrementEssenceShiftKills()
		end

		local permanent_agi_gain_modifier = self:GetParent():FindModifierByName( self.permanent_agi_gain_modifier_name )
		if not permanent_agi_gain_modifier then
			permanent_agi_gain_modifier = self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_slark_essence_shift_lua_gain",
				{}
			)
		end
		permanent_agi_gain_modifier:SetStackCount( self:GetAbility():GetEssenceShiftKills() )
		permanent_agi_gain_modifier:ForceRefresh()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_essence_shift_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end