modifier_sniper_shrapnel_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_shrapnel_lua:IsHidden()
	return false
end

function modifier_sniper_shrapnel_lua:IsDebuff()
	return true
end

function modifier_sniper_shrapnel_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_shrapnel_lua:OnCreated( kv )
	-- references
	self.caster = self:GetAbility():GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" ) + (self.caster:GetAgility() * self:GetAbility():GetSpecialValueFor( "agi_multiplier" )) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value

	local interval = 1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self.caster,
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
	end
end

function modifier_sniper_shrapnel_lua:OnRefresh( kv )
	
end

function modifier_sniper_shrapnel_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_shrapnel_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_sniper_shrapnel_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_shrapnel_lua:OnIntervalThink()
	-- if self.caster:IsAlive() then
		ApplyDamage(self.damageTable)
	-- end
end