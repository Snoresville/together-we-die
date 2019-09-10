modifier_slark_essence_shift_lua = class({})
local tempTable = require("util/tempTable")
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua:IsHidden()
	return false
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
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.permanent_agi_gain_modifier_name = "modifier_slark_essence_shift_lua_gain"
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_slark_essence_shift_lua:OnRefresh( kv )
	-- references
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
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
		if target:IsIllusion() then
			return
		end

		-- Apply debuff to enemy
		local debuff = params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_slark_essence_shift_lua_debuff",
			{
				stack_duration = self.duration,
			}
		)

		-- Apply buff to self
		self:AddStack( duration )

		-- Play effects
		self:PlayEffects( params.target )
	end
end

function modifier_slark_essence_shift_lua:OnDeath( event )
	if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() then
		return
	end

	if event.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsAlive() and event.attacker == self:GetParent() then
		self:GetAbility():IncrementEssenceShiftKills()

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

function modifier_slark_essence_shift_lua:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self.agi_gain
end

--------------------------------------------------------------------------------
-- Helper
function modifier_slark_essence_shift_lua:AddStack( duration )
	-- Add counter
	local parent = tempTable:AddATValue( self )
	self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_slark_essence_shift_lua_stack",
		{
			duration = self.duration,
			modifier = parent,
		}
	)

	-- Add stack
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_lua:RemoveStack()
	self:DecrementStackCount()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_essence_shift_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end