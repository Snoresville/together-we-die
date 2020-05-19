modifier_pudge_dismember_lua = class({})

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------
function modifier_pudge_dismember_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
function modifier_pudge_dismember_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.str_multiplier = self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )
	-- Talent Tree
	local special_dismember_str_multiplier_lua = self:GetCaster():FindAbilityByName("special_dismember_str_multiplier_lua")
	if special_dismember_str_multiplier_lua and special_dismember_str_multiplier_lua:GetLevel() ~= 0 then
		self.str_multiplier = self.str_multiplier + special_dismember_str_multiplier_lua:GetSpecialValueFor("value")
		self.strength_damage_scepter = self.strength_damage_scepter + special_dismember_str_multiplier_lua:GetSpecialValueFor("value")
	end

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnDestroy()
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		if self:GetCaster():HasScepter() then
			-- Scepter grants heal and more strength damage
			flDamage = flDamage + ( self:GetCaster():GetStrength() * self.strength_damage_scepter )
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		else
			-- No scepter, grants only base str dmg
			flDamage = flDamage + ( self:GetCaster():GetStrength() * self.str_multiplier )
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------
