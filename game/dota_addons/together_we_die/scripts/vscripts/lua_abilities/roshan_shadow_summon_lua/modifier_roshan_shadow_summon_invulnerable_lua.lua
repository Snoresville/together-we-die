modifier_roshan_shadow_summon_invulnerable_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_shadow_summon_invulnerable_lua:IsHidden()
	return false
end

function modifier_roshan_shadow_summon_invulnerable_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_shadow_summon_invulnerable_lua:OnCreated( kv )
end

function modifier_roshan_shadow_summon_invulnerable_lua:OnRefresh( kv )
	
end

function modifier_roshan_shadow_summon_invulnerable_lua:OnRemoved()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_roshan_shadow_summon_invulnerable_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end


--------------------------------------------------------------------------------
-- Status Effects
function modifier_roshan_shadow_summon_invulnerable_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true
	}

	return state
end