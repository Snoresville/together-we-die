modifier_sven_warcry_lua = class({})
--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:OnCreated( kv )
	local eCaster = self:GetCaster()
	local eAbility = self:GetAbility()
	self.warcry_armor = eAbility:GetSpecialValueFor( "warcry_armor" ) + (eCaster:GetStrength() * eAbility:GetSpecialValueFor("str_multiplier"))
	self.warcry_movespeed = eAbility:GetSpecialValueFor( "warcry_movespeed" )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, eCaster, PATTACH_POINT_FOLLOW, "attach_head", eCaster:GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:OnRefresh( kv )
	local eCaster = self:GetCaster()
	local eAbility = self:GetAbility()
	self.warcry_armor = eAbility:GetSpecialValueFor( "warcry_armor" ) + (eCaster:GetStrength() * eAbility:GetSpecialValueFor("str_multiplier"))
	self.warcry_movespeed = eAbility:GetSpecialValueFor( "warcry_movespeed" )
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetActivityTranslationModifiers( params )
	if self:GetParent() == self:GetCaster() then
		return "sven_warcry"
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self.warcry_movespeed
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetModifierPhysicalArmorBonus( params )
	return self.warcry_armor
end

--------------------------------------------------------------------------------