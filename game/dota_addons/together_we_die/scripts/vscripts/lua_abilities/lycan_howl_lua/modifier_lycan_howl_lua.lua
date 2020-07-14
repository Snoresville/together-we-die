modifier_lycan_howl_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_howl_lua:IsHidden()
    return false
end

function modifier_lycan_howl_lua:IsDebuff()
    return true
end

function modifier_lycan_howl_lua:IsPurgable()
    return true
end

-- Initializations
function modifier_lycan_howl_lua:OnCreated( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "attack_damage_reduction" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor" ) + (self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("armor_decrease_per_strength"))
end

function modifier_lycan_howl_lua:OnRefresh( kv )
	-- references
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "attack_damage_reduction" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor" ) + (self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("armor_decrease_per_strength"))
end

function modifier_lycan_howl_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lycan_howl_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end
function modifier_lycan_howl_lua:GetModifierPhysicalArmorBonus()
	return -self.armor_reduction
end
function modifier_lycan_howl_lua:GetModifierBaseDamageOutgoing_Percentage()
	return -self.damage_reduction
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_lycan_howl_lua:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_lycan_howl_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end