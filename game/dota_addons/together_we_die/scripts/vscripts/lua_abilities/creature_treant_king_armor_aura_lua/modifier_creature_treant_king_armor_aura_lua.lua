modifier_creature_treant_king_armor_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_treant_king_armor_aura_lua:IsHidden()
	return true
end

function modifier_creature_treant_king_armor_aura_lua:IsDebuff()
	return false
end

function modifier_creature_treant_king_armor_aura_lua:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_creature_treant_king_armor_aura_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end
function modifier_creature_treant_king_armor_aura_lua:GetModifierAura()
	return "modifier_creature_treant_king_armor_aura_effect_lua"
end

function modifier_creature_treant_king_armor_aura_lua:GetAuraRadius()
	return self.radius
end

function modifier_creature_treant_king_armor_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_creature_treant_king_armor_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_treant_king_armor_aura_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_creature_treant_king_armor_aura_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end