modifier_centaur_warrunner_return_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_centaur_warrunner_return_lua:IsHidden()
	return true
end

function modifier_centaur_warrunner_return_lua:IsDebuff()
	return false
end

function modifier_centaur_warrunner_return_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_centaur_warrunner_return_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
end

function modifier_centaur_warrunner_return_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
end

--------------------------------------------------------------------------------
-- Aura
function modifier_centaur_warrunner_return_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_centaur_warrunner_return_lua:GetModifierAura()
	return "modifier_centaur_warrunner_return_lua_effect"
end

function modifier_centaur_warrunner_return_lua:GetAuraRadius()
	return self.radius
end

function modifier_centaur_warrunner_return_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_centaur_warrunner_return_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

--------------------------------------------------------------------------------
function modifier_centaur_warrunner_return_lua:GetAuraEntityReject(hEntity)
	if self:GetCaster() == hEntity then
		return false
	end

	-- Talent tree for return Aura mode
	local special_return_aura_lua = self:GetCaster():FindAbilityByName( "special_return_aura_lua" )
	if ( special_return_aura_lua and special_return_aura_lua:GetLevel() ~= 0 ) then
		return false
	end

	return true
end