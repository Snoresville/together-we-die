modifier_spectre_desolate_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_desolate_lua:IsHidden()
	return true
end

function modifier_spectre_desolate_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spectre_desolate_lua:OnCreated( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_spectre_desolate_lua:OnRefresh( kv )
	-- references
	self.hits_required = self:GetAbility():GetSpecialValueFor( "hits_required" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_spectre_desolate_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spectre_desolate_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_spectre_desolate_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack modifier
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_spectre_desolate_lua_stack", -- modifier name
		{} -- kv
	)
	local stack_count = self:GetParent():GetModifierStackCount( "modifier_spectre_desolate_lua_stack", self:GetCaster() ) or 0
	if stack_count >= self.hits_required then
		params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_spectre_desolate_lua_debuff",
			{ duration = self.duration }
		)

		-- Effects
		EmitSoundOn( "Hero_Spectre.Desolate", params.target )
		self:GetParent():RemoveModifierByName( "modifier_spectre_desolate_lua_stack" )
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
