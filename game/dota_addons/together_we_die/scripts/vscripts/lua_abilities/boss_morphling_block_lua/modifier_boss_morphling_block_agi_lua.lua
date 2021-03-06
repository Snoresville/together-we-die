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
	if IsServer() then
		local parent = self:GetParent()
		parent:SetRenderColor( 0, 255, 0 )
	end
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

		-- allow only buildings or agi hero to deal damage
		if attacker:IsBuilding() or attacker:IsRealHero() and attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
			reduction = 0
		else
			if attacker:IsRealHero() and attacker:IsAlive() then
				-- Heal morphling if is hero
				local healHealth = parent:GetMaxHealth() * 0.01
				parent:Heal( healHealth, parent )
			end

			local damageToDeal = math.floor(attacker:GetMaxHealth() * 0.25)
			local damageTable = {
				victim = attacker,
				attacker = parent,
				damage = damageToDeal,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			}
			ApplyDamage( damageTable )
		end

		return reduction
	end
end