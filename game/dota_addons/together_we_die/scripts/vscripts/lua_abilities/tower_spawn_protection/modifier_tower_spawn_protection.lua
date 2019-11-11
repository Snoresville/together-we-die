modifier_tower_spawn_protection = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tower_spawn_protection:IsHidden()
	return true
end

function modifier_tower_spawn_protection:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tower_spawn_protection:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_tower_spawn_protection:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_tower_spawn_protection:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Classifications
function modifier_tower_spawn_protection:IsHidden()
	return true
end

function modifier_tower_spawn_protection:IsDebuff()
	return false
end

function modifier_tower_spawn_protection:IsPurgable()
	return false
end

function modifier_tower_spawn_protection:IsAura()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetModifierAura()
	return "modifier_tower_spawn_protection_effect"
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraSearchType()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraEntityReject( hEntity )
	-- prevent units spawned that cannot move from being invulnerable
	if self:GetCaster() ~= hEntity and not hEntity:HasMovementCapability() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection:GetAuraRadius()
	return self.radius
end