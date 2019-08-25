modifier_roshan_defective_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:OnRefresh( kv )
end


--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:GetDisableHealing()
	return true
end

--------------------------------------------------------------------------------

function modifier_roshan_defective_aura_effect_lua:CheckState()
	local state = {}

	if IsServer() and not self:GetCaster():PassivesDisabled() then
		if self:GetParent():IsHero() and self:GetParent():GetPrimaryAttribute() ~= 2 then
			-- not intelligence, silence them
			state = {
				[MODIFIER_STATE_MUTED] = true,
				[MODIFIER_STATE_INVISIBLE] = false,
				[MODIFIER_STATE_BLOCK_DISABLED] = true,
				[MODIFIER_STATE_EVADE_DISABLED] = true,
				[MODIFIER_STATE_PASSIVES_DISABLED] = true,
				[MODIFIER_STATE_SILENCED] = true,
			}
		else
			-- is intelligence, dont silence
			state = {
				[MODIFIER_STATE_MUTED] = true,
				[MODIFIER_STATE_INVISIBLE] = false,
				[MODIFIER_STATE_BLOCK_DISABLED] = true,
				[MODIFIER_STATE_EVADE_DISABLED] = true,
				[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			}
		end
		
	end

	return state
end


--------------------------------------------------------------------------------

