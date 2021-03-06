modifier_boss_morphling_block_str_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_boss_morphling_block_str_lua:IsHidden()
	return false
end

function modifier_boss_morphling_block_str_lua:IsDebuff()
	return false
end

function modifier_boss_morphling_block_str_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_boss_morphling_block_str_lua:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
		parent:SetRenderColor( 255, 0, 0 )
	end
end

function modifier_boss_morphling_block_str_lua:OnRefresh( kv )

end

function modifier_boss_morphling_block_str_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_boss_morphling_block_str_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_boss_morphling_block_str_lua:GetModifierIncomingDamage_Percentage( params )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = params.attacker
		local reduction = -100

		-- allow only strength hero to deal damage
		if attacker:IsBuilding() or attacker:IsRealHero() and attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
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
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
			}
			ApplyDamage( damageTable )
		end

		return reduction
	end
end