modifier_item_octarine_core_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_octarine_core_lua:IsHidden()
	return true
end

function modifier_item_octarine_core_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_octarine_core_lua:OnCreated( kv )
	-- references
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_mana = self:GetAbility():GetSpecialValueFor( "bonus_mana" )
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
	self.creep_lifesteal = self:GetAbility():GetSpecialValueFor( "creep_lifesteal" )
end

function modifier_item_octarine_core_lua:OnRefresh( kv )
	-- references
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_mana = self:GetAbility():GetSpecialValueFor( "bonus_mana" )
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
	self.creep_lifesteal = self:GetAbility():GetSpecialValueFor( "creep_lifesteal" )
end

function modifier_item_octarine_core_lua:OnDestroy( kv )

end

function modifier_item_octarine_core_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE
end

-- Modifier Effects
function modifier_item_octarine_core_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}

	return funcs
end

function modifier_item_octarine_core_lua:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_item_octarine_core_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua:OnTakeDamage( params )
	if IsServer() then
		--if params.attacker == self:GetParent() then
			--for k,v in pairs(params) do
				--print(k,v)
			--end
		--end
		-- filter
		local pass = false
		if (params.damage_type == DAMAGE_TYPE_MAGICAL or params.damage_category == 0) and params.attacker == self:GetParent() and params.unit ~= self:GetParent() and self:GetParent():GetTeamNumber() ~= params.unit:GetTeamNumber() then
			pass = true
		end

		-- logic
		if pass then
			-- get heal value
			local heal = params.damage * self.creep_lifesteal/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_octarine_core_lua:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/items3_fx/octarine_core_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end