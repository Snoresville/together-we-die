modifier_creature_bleeding_bash_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_bleeding_bash_lua:IsHidden()
	return true
end

function modifier_creature_bleeding_bash_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_bleeding_bash_lua:OnCreated( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.bleed_duration = self:GetAbility():GetSpecialValueFor( "bleed_duration" )
end

function modifier_creature_bleeding_bash_lua:OnRefresh( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.bleed_duration = self:GetAbility():GetSpecialValueFor( "bleed_duration" )
end

function modifier_creature_bleeding_bash_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_bleeding_bash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_creature_bleeding_bash_lua:OnAttackLanded( params )
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
	local stack_count = self:GetParent():GetModifierStackCount( "modifier_creature_bleeding_bash_lua_stack", self:GetCaster() ) or 0
	if stack_count >= self.hits_required then
		-- apply damage
		local damageTable = {
			victim = params.target,
			attacker = self:GetParent(),
			damage = self.damage,
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

		params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_creature_bleeding_bash_lua_bleed",
				{ duration = self.bleed_duration }
		)

		-- Effects
		EmitSoundOn( "Hero_Slardar.Bash", params.target )
		self:GetParent():RemoveModifierByName( "modifier_slardar_bash_of_the_deep_lua_stack" )
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
