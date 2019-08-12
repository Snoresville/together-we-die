modifier_creature_chaos_protect_light_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:OnRefresh( kv )
end


--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_chaos_protect_light_effect_lua:GetModifierIncomingDamage_Percentage( params )
	if IsServer() then
		return -100
	end
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

