modifier_slardar_guardian_sprint_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slardar_guardian_sprint_lua:IsHidden()
	return false
end

function modifier_slardar_guardian_sprint_lua:IsDebuff()
	return false
end

function modifier_slardar_guardian_sprint_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slardar_guardian_sprint_lua:OnCreated( kv )
	-- references
	local str_bonus = self:GetParent():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	self.bonus_speed = self:GetAbility():GetSpecialValueFor( "bonus_speed" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + str_bonus
	self.river_speed = self:GetAbility():GetSpecialValueFor( "river_speed" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" ) + str_bonus/3

	if self:GetAbility():GetLevel()>=4 then
		self.haste = true
	end
end

function modifier_slardar_guardian_sprint_lua:OnRefresh( kv )
	-- references
	local str_bonus = self:GetParent():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	self.bonus_speed = self:GetAbility():GetSpecialValueFor( "bonus_speed" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + str_bonus
	self.river_speed = self:GetAbility():GetSpecialValueFor( "river_speed" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" ) + str_bonus/3

	if self:GetAbility():GetLevel()>=4 then
		self.haste = true
	end
end

function modifier_slardar_guardian_sprint_lua:OnDestroy( kv )

end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slardar_guardian_sprint_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_slardar_guardian_sprint_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_slardar_guardian_sprint_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_speed
end
function modifier_slardar_guardian_sprint_lua:GetModifierConstantHealthRegen()
	return self.bonus_regen
end
function modifier_slardar_guardian_sprint_lua:GetModifierMoveSpeed_Absolute()
	if IsServer() then
		-- check if in the river
		if self.haste then
			if self:GetParent():GetOrigin().z <=0.5 then
				return self.river_speed
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_slardar_guardian_sprint_lua:CheckState()
	local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slardar_guardian_sprint_lua:GetEffectName()
	return "particles/units/heroes/hero_slardar/slardar_sprint.vpcf"
end

function modifier_slardar_guardian_sprint_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
