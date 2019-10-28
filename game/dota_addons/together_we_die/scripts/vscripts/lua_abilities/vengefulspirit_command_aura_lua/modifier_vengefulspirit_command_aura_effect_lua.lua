modifier_vengefulspirit_command_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:IsDebuff()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:OnCreated( kv )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self:OnIntervalThink()
	self:StartIntervalThink( 1.0 )
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:OnRefresh( kv )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self:OnIntervalThink()
end


--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return -self.total_bonus_damage_pct
	end

	return self.total_bonus_damage_pct
end

function modifier_vengefulspirit_command_aura_effect_lua:OnIntervalThink()
	self.total_bonus_damage_pct = self.bonus_damage_pct + self.agi_multiplier * self:GetCaster():GetAgility()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

