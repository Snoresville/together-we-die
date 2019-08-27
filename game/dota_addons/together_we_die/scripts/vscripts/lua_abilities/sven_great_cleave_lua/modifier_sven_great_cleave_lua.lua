modifier_sven_great_cleave_lua = class({})

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnCreated( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.starting_width = self:GetAbility():GetSpecialValueFor( "starting_width" )
	self.ending_width = self:GetAbility():GetSpecialValueFor( "ending_width" )
	self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.str_multiplier = self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	-- start interval
	self:OnIntervalThink()
	local interval = 1
	self:StartIntervalThink( interval )
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnRefresh( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.starting_width = self:GetAbility():GetSpecialValueFor( "starting_width" )
	self.ending_width = self:GetAbility():GetSpecialValueFor( "ending_width" )
	self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.str_multiplier = self:GetAbility():GetSpecialValueFor( "str_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.great_cleave_damage * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.starting_width, self.ending_width, self.distance, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	
	return 0
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:GetModifierPreAttack_BonusDamage( params )
	return self.calculated_bonus_damage
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnIntervalThink()
	self.calculated_bonus_damage = self.bonus_damage + math.floor(self:GetParent():GetStrength() * self.str_multiplier) -- special value
end