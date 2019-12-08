modifier_dazzle_bad_juju_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_bad_juju_lua_debuff:IsHidden()
	return false
end

function modifier_dazzle_bad_juju_lua_debuff:IsDebuff()
	return true
end

function modifier_dazzle_bad_juju_lua_debuff:IsStunDebuff()
	return false
end

function modifier_dazzle_bad_juju_lua_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dazzle_bad_juju_lua_debuff:OnCreated( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) + math.floor(self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "int_multiplier" ))
	self:SetStackCount( 1 )
end

function modifier_dazzle_bad_juju_lua_debuff:OnRefresh( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) + math.floor(self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "int_multiplier" ))
	self:IncrementStackCount()
end

function modifier_dazzle_bad_juju_lua_debuff:OnRemoved()
end

function modifier_dazzle_bad_juju_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_bad_juju_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_dazzle_bad_juju_lua_debuff:GetModifierPhysicalArmorBonus()
	return -(self:GetStackCount() * self.armor_reduction)
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dazzle_bad_juju_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf"
end

function modifier_dazzle_bad_juju_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
