modifier_legion_commander_press_the_attack_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_legion_commander_press_the_attack_lua:IsHidden()
	return false
end

function modifier_legion_commander_press_the_attack_lua:IsDebuff()
	return false
end

function modifier_legion_commander_press_the_attack_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_legion_commander_press_the_attack_lua:OnCreated( kv )
	-- references
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" ) + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_legion_commander_press_the_attack_lua:OnRefresh( kv )
	-- references
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" ) + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "str_multiplier" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_legion_commander_press_the_attack_lua:OnRemoved()
end

function modifier_legion_commander_press_the_attack_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_legion_commander_press_the_attack_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_legion_commander_press_the_attack_lua:GetModifierConstantHealthRegen()
	return self.hp_regen
end

function modifier_legion_commander_press_the_attack_lua:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_legion_commander_press_the_attack_lua:GetEffectName()
	return "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf"
end

function modifier_legion_commander_press_the_attack_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
