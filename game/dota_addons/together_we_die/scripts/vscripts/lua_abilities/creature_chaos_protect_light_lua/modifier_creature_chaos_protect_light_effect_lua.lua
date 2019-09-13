modifier_creature_chaos_protect_light_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:IsDebuff()
	return false
end

function modifier_creature_chaos_protect_light_effect_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:OnRefresh( kv )
end

function modifier_creature_chaos_protect_light_effect_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}

	return state
end