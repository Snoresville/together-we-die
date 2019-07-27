-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_summoning_stone_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_summoning_stone_lua:IsHidden()
	return true
end

function modifier_summoning_stone_lua:IsDebuff()
	return false
end

function modifier_summoning_stone_lua:IsPurgable()
	return false
end

function modifier_summoning_stone_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:GetModifierAura()
	return "modifier_summoning_stone_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_summoning_stone_lua:GetAuraEntityReject(hEntity)
	if self:GetCaster() ~= hEntity and hEntity:GetOwner() == self:GetCaster() and not hEntity:IsHero() then
		return false
	else
		return true
	end
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_summoning_stone_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_summoning_stone_lua:OnIntervalThink()
	if self:GetCaster() ~= self:GetParent() and self:GetCaster():IsAlive() then
		self:Destroy()
	end
end