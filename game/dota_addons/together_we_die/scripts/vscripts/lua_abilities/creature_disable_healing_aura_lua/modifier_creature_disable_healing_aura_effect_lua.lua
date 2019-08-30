modifier_creature_disable_healing_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_creature_disable_healing_aura_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_disable_healing_aura_effect_lua:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_creature_disable_healing_aura_effect_lua:OnRefresh( kv )
end


--------------------------------------------------------------------------------

function modifier_creature_disable_healing_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_disable_healing_aura_effect_lua:GetDisableHealing( params )
	return 1
end