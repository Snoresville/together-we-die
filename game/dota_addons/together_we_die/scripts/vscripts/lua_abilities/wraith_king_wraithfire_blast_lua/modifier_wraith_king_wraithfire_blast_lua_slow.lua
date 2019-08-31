modifier_wraith_king_wraithfire_blast_lua_slow = class({})

--------------------------------------------------------------------------------

function modifier_wraith_king_wraithfire_blast_lua_slow:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_wraith_king_wraithfire_blast_lua_slow:OnCreated( kv )
	self.dot_damage = self:GetAbility():GetSpecialValueFor( "blast_dot_damage" ) + (self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" ) / 5)
	self.dot_slow = self:GetAbility():GetSpecialValueFor( "blast_slow" )
	self.tick = 0
	self.interval = self:GetRemainingTime()/kv.duration -- in case of status resistance
	self.duration = kv.duration

	self:StartIntervalThink( self.interval )
end

function modifier_wraith_king_wraithfire_blast_lua_slow:OnRefresh( kv )
	self.dot_damage = self:GetAbility():GetSpecialValueFor( "blast_dot_damage" ) + (self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" ) / 5)
	self.dot_slow = self:GetAbility():GetSpecialValueFor( "blast_slow" )
	self.tick = 0
	self.interval = self:GetRemainingTime()/kv.duration -- in case of status resistance
	self.duration = kv.duration

	self:StartIntervalThink( self.interval )
end

function modifier_wraith_king_wraithfire_blast_lua_slow:OnDestroy()
	if IsServer() then
		-- make sure last tick must happened
		if self.tick < self.duration then
			self:OnIntervalThink()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_wraith_king_wraithfire_blast_lua_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_wraith_king_wraithfire_blast_lua_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.dot_slow
end

--------------------------------------------------------------------------------

function modifier_wraith_king_wraithfire_blast_lua_slow:OnIntervalThink()
	if IsServer() then
		-- Apply DoT
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.dot_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )
	end

	-- add tick
	self.tick = self.tick + 1
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wraith_king_wraithfire_blast_lua_slow:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
end

function modifier_wraith_king_wraithfire_blast_lua_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end