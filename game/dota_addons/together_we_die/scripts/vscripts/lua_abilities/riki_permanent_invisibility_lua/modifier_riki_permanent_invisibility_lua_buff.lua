modifier_riki_permanent_invisibility_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_permanent_invisibility_lua_buff:IsHidden()
	return false
end

function modifier_riki_permanent_invisibility_lua_buff:IsDebuff()
	return false
end

function modifier_riki_permanent_invisibility_lua_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_permanent_invisibility_lua_buff:OnCreated( kv )
	-- references
	self.ability_reveal = self:GetAbility():GetSpecialValueFor("ability_reveal")
	self.attack_reveal = self:GetAbility():GetSpecialValueFor("attack_reveal")
	self.true_sight_immuned = self:GetAbility():GetSpecialValueFor("true_sight_immune")
end

function modifier_riki_permanent_invisibility_lua_buff:OnRefresh( kv )
	-- references
	self.ability_reveal = self:GetAbility():GetSpecialValueFor("ability_reveal")
	self.attack_reveal = self:GetAbility():GetSpecialValueFor("attack_reveal")
	self.true_sight_immuned = self:GetAbility():GetSpecialValueFor("true_sight_immune")
end

function modifier_riki_permanent_invisibility_lua_buff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_riki_permanent_invisibility_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_riki_permanent_invisibility_lua_buff:GetModifierInvisibilityLevel()
	return 1
end

function modifier_riki_permanent_invisibility_lua_buff:OnAbilityExecuted( params )
	if IsServer() then
		if not self.ability_reveal then return end
		if params.unit~=self:GetParent() then return end

		self:Destroy()
	end
end

function modifier_riki_permanent_invisibility_lua_buff:OnAttack( params )
	if IsServer() then
		if not self.attack_reveal then return end
		if params.attacker~=self:GetParent() then return end

		self:Destroy()
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_riki_permanent_invisibility_lua_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = (not self:GetParent():PassivesDisabled()),
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = (self.true_sight_immuned and not self:GetParent():PassivesDisabled()),
	}

	return state
end