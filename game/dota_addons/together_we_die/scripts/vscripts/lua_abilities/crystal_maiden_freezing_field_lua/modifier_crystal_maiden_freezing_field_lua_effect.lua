modifier_crystal_maiden_freezing_field_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystal_maiden_freezing_field_lua_effect:IsHidden()
	return false
end

function modifier_crystal_maiden_freezing_field_lua_effect:IsDebuff()
	return true
end

function modifier_crystal_maiden_freezing_field_lua_effect:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_freezing_field_lua_effect:OnCreated( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
	self.delay = self:GetAbility():GetSpecialValueFor( "scepter_delay" )

	if not IsServer() then return end
	if self:GetCaster():HasScepter() then
		local interval = 0.5
		self.count = 0
		self:StartIntervalThink( interval )
	end
end

function modifier_crystal_maiden_freezing_field_lua_effect:OnRefresh( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )	
	self.delay = self:GetAbility():GetSpecialValueFor( "scepter_delay" )
end

function modifier_crystal_maiden_freezing_field_lua_effect:OnDestroy( kv )

end

function modifier_crystal_maiden_freezing_field_lua_effect:OnIntervalThink()
	self.count = self.count + 0.5
	if self.count >= self.delay then
		local caster = self:GetCaster()
		local victim = self:GetParent()
		self.count = 0

		local frostBite = caster:FindAbilityByName( "crystal_maiden_frostbite_lua" )
		if (frostBite) then
			caster:SetCursorCastTarget( victim )
			frostBite:OnSpellStart()
		end
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_crystal_maiden_freezing_field_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_crystal_maiden_freezing_field_lua_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_crystal_maiden_freezing_field_lua_effect:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_crystal_maiden_freezing_field_lua_effect:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_crystal_maiden_freezing_field_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end