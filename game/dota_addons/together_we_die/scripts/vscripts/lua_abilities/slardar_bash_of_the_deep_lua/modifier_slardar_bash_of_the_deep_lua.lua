modifier_slardar_bash_of_the_deep_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slardar_bash_of_the_deep_lua:IsHidden()
	return true
end

function modifier_slardar_bash_of_the_deep_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slardar_bash_of_the_deep_lua:OnCreated( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.str_multiplier = self:GetAbility():GetSpecialValueFor( "str_multiplier" )
end

function modifier_slardar_bash_of_the_deep_lua:OnRefresh( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.str_multiplier = self:GetAbility():GetSpecialValueFor( "str_multiplier" )
end

function modifier_slardar_bash_of_the_deep_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slardar_bash_of_the_deep_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_slardar_bash_of_the_deep_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack modifier
	local modifier = self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_slardar_bash_of_the_deep_lua_stack", -- modifier name
		{} -- kv
	)
	local stack_count = self:GetParent():GetModifierStackCount( "modifier_slardar_bash_of_the_deep_lua_stack", self:GetCaster() ) or 0
	if stack_count >= self.hits_required then
		-- apply damage
		local damageTable = {
			victim = params.target,
			attacker = self:GetParent(),
			damage = self.damage + self:GetParent():GetStrength() * self.str_multiplier,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)

		params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_generic_bashed_lua",
			{ duration = self.duration }
		)

		-- Effects
		EmitSoundOn( "Hero_Slardar.Bash", params.target )
		self:GetParent():RemoveModifierByName( "modifier_slardar_bash_of_the_deep_lua_stack" )
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
