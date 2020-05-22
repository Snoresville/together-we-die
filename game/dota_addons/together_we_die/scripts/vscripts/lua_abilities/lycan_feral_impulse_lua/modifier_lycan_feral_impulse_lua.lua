modifier_lycan_feral_impulse_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_feral_impulse_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------
-- Aura
function modifier_lycan_feral_impulse_lua:IsAura()
	return true
end

function modifier_lycan_feral_impulse_lua:GetModifierAura()
	return "modifier_lycan_feral_impulse_lua_aura"
end

function modifier_lycan_feral_impulse_lua:GetAuraRadius()
	return self.aura_radius
end

function modifier_lycan_feral_impulse_lua:GetAuraSearchTeam()
	if not self:GetParent():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_lycan_feral_impulse_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_lycan_feral_impulse_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_lycan_feral_impulse_lua:OnCreated( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
end

function modifier_lycan_feral_impulse_lua:OnRefresh( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
end