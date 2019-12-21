modifier_creature_enchantress_untouchable_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_enchantress_untouchable_lua_debuff:IsHidden()
	return false
end

function modifier_creature_enchantress_untouchable_lua_debuff:IsDebuff()
	return true
end

function modifier_creature_enchantress_untouchable_lua_debuff:IsStunDebuff()
	return false
end

function modifier_creature_enchantress_untouchable_lua_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_enchantress_untouchable_lua_debuff:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self:SetStackCount(1)
end

function modifier_creature_enchantress_untouchable_lua_debuff:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self:IncrementStackCount()
end

function modifier_creature_enchantress_untouchable_lua_debuff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_enchantress_untouchable_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_creature_enchantress_untouchable_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.slow
end

function modifier_creature_enchantress_untouchable_lua_debuff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_reduction
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_enchantress_untouchable_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_creature_enchantress_untouchable_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end