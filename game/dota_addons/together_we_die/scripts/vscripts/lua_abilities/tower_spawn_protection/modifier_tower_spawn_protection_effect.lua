modifier_tower_spawn_protection_effect = class({})

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection_effect:IsDebuff()
	return false
end

function modifier_tower_spawn_protection_effect:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection_effect:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_tower_spawn_protection_effect:OnRefresh( kv )
end

function modifier_tower_spawn_protection_effect:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end