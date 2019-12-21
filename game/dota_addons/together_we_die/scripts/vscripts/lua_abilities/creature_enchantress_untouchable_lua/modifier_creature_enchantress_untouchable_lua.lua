modifier_creature_enchantress_untouchable_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_enchantress_untouchable_lua:IsHidden()
	return true
end

function modifier_creature_enchantress_untouchable_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_enchantress_untouchable_lua:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
end

function modifier_creature_enchantress_untouchable_lua:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
end

function modifier_creature_enchantress_untouchable_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_enchantress_untouchable_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
	}

	return funcs
end

function modifier_creature_enchantress_untouchable_lua:OnAttackStart( params )
	if IsServer() then
		if params.target~=self:GetParent() then return end

		-- cancel if is not a building and is immune
		if params.attacker:IsMagicImmune() and not params.attacker:IsBuilding() then return end

		-- cancel if break
		if self:GetParent():PassivesDisabled() then return end

		-- add modifier
		params.attacker:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_creature_enchantress_untouchable_lua_debuff", -- modifier name
			{ duration = self.duration } -- kv
		)
	end
end