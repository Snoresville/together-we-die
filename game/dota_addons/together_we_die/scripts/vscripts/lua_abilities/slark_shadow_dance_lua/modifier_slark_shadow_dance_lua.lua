modifier_slark_shadow_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua:IsHidden()
	return true
end

function modifier_slark_shadow_dance_lua:IsDebuff()
	return false
end

function modifier_slark_shadow_dance_lua:IsPurgable()
	return false
end
function modifier_slark_shadow_dance_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Aura
function modifier_slark_shadow_dance_lua:IsAura()
	return true
end

function modifier_slark_shadow_dance_lua:GetModifierAura()
	return "modifier_slark_shadow_dance_lua_invis"
end

function modifier_slark_shadow_dance_lua:GetAuraRadius()
	return self.scepter_aoe
end

function modifier_slark_shadow_dance_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_slark_shadow_dance_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_slark_shadow_dance_lua:GetAuraDuration()
	return 0.5
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua:OnCreated( kv )
	-- references
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" ) -- special value
end

function modifier_slark_shadow_dance_lua:OnRefresh( kv )
	-- references
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" ) -- special value
end

function modifier_slark_shadow_dance_lua:OnDestroy( kv )

end
