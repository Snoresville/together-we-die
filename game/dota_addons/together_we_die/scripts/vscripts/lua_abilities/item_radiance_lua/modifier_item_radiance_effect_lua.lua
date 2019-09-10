modifier_item_radiance_effect_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_radiance_effect_lua:IsHidden()
	return false
end

function modifier_item_radiance_effect_lua:IsDebuff()
	return true
end

function modifier_item_radiance_effect_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_radiance_effect_lua:OnCreated( kv )
	-- references
	self.aura_damage = self:GetAbility():GetSpecialValueFor( "aura_damage" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
	self.blind_pct = self:GetAbility():GetSpecialValueFor( "blind_pct" )
	self.damage_tick = self:GetAbility():GetSpecialValueFor( "damage_tick" )

	self:StartIntervalThink( self.damage_tick )
	self:OnIntervalThink()
end

function modifier_item_radiance_effect_lua:OnRefresh( kv )
	-- references
	self.aura_damage = self:GetAbility():GetSpecialValueFor( "aura_damage" )
	self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
	self.blind_pct = self:GetAbility():GetSpecialValueFor( "blind_pct" )
	self.damage_tick = self:GetAbility():GetSpecialValueFor( "damage_tick" )

	self:StartIntervalThink( self.damage_tick )
	self:OnIntervalThink()
end

function modifier_item_radiance_effect_lua:OnDestroy( kv )

end

function modifier_item_radiance_effect_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_radiance_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_item_radiance_effect_lua:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.damage_tick * (self.aura_damage + (self:GetCaster():GetPrimaryStatValue() * self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )))

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage( damage )
		end
	end
end
