--------------------------------------------------------------------------------
modifier_roshan_defective_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_defective_aura_lua:IsHidden()
	return true
end

function modifier_roshan_defective_aura_lua:IsDebuff()
	return false
end

function modifier_roshan_defective_aura_lua:IsPurgable()
	return false
end

function modifier_roshan_defective_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:GetModifierAura()
	return "modifier_roshan_defective_aura_effect_lua"
end

--------------------------------------------------------------------------------
function modifier_roshan_defective_aura_lua:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end

function modifier_roshan_defective_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_roshan_defective_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:OnCreated( kv )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_lua:OnRefresh( kv )
end

function modifier_roshan_defective_aura_lua:OnIntervalThink()
	if self:GetCaster() ~= self:GetParent() and self:GetCaster():IsAlive() then
		self:Destroy()
	end
end