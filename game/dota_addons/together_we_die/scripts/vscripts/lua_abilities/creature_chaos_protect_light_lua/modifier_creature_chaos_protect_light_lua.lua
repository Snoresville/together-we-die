--------------------------------------------------------------------------------
modifier_creature_chaos_protect_light_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_chaos_protect_light_lua:IsHidden()
	return true
end

function modifier_creature_chaos_protect_light_lua:IsDebuff()
	return false
end

function modifier_creature_chaos_protect_light_lua:IsPurgable()
	return false
end

function modifier_creature_chaos_protect_light_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:GetModifierAura()
	return "modifier_creature_chaos_protect_light_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------
function modifier_creature_chaos_protect_light_lua:GetAuraEntityReject(hEntity)
	if self:GetCaster() ~= hEntity and hEntity:GetUnitName() == "npc_dota_creature_keeper_of_the_light" then
		return false
	else
		return true
	end
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_creature_chaos_protect_light_lua:OnIntervalThink()
	if self:GetCaster() ~= self:GetParent() and self:GetCaster():IsAlive() then
		self:Destroy()
	end
end