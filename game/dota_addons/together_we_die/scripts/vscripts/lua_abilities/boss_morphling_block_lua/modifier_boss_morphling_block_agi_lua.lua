modifier_boss_morphling_block_agi_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_boss_morphling_block_agi_lua:IsHidden()
	return false
end

function modifier_boss_morphling_block_agi_lua:IsDebuff()
	return false
end

function modifier_boss_morphling_block_agi_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_boss_morphling_block_agi_lua:OnCreated( kv )

end

function modifier_boss_morphling_block_agi_lua:OnRefresh( kv )

end

function modifier_boss_morphling_block_agi_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_boss_morphling_block_agi_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_boss_morphling_block_agi_lua:GetModifierIncomingDamage_Percentage( params )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = params.attacker
		local reduction = -100

		-- allow only agi hero to deal damage
		if attacker:IsHero() and attacker:GetPrimaryAttribute() == 1 then
			reduction = 0
		end

		return reduction
	end
end