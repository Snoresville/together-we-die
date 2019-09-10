modifier_item_radiance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_radiance_lua:IsHidden()
	return true
end

function modifier_item_radiance_lua:IsPurgable()
	return false
end

function modifier_item_radiance_lua:IsAura()
	return true
end

function modifier_item_radiance_lua:GetModifierAura()
	return "modifier_item_radiance_effect_lua"
end

function modifier_item_radiance_lua:GetAuraRadius()
	-- cancel if break
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.aura_radius
end

function modifier_item_radiance_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_radiance_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_radiance_lua:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_item_radiance_lua:OnRefresh( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_item_radiance_lua:OnDestroy( kv )

end

function modifier_item_radiance_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Modifier Effects
function modifier_item_radiance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_item_radiance_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end