modifier_creature_acid_death_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:OnCreated( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.tick_damage = self:GetAbility():GetSpecialValueFor( "tick_damage" )
	self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )

	if IsServer() then
		self.damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		self:StartIntervalThink( self.tick_interval )
		self:OnIntervalThink()
	end
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:OnRefresh( kv )
end


--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:GetModifierPhysicalArmorBonus( params )
	if IsServer() then
		return self.armor_reduction
	end
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_effect_lua:OnIntervalThink()
	if IsServer() then
		ApplyDamage( self.damage )
	end
end

--------------------------------------------------------------------------------

