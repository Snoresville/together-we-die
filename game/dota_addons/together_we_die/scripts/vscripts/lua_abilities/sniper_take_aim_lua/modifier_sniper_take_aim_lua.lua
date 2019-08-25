modifier_sniper_take_aim_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_take_aim_lua:IsHidden()
	return true
end

function modifier_sniper_take_aim_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_take_aim_lua:OnCreated( kv )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	-- start interval
	self:OnIntervalThink()
	local interval = 1
	self:StartIntervalThink( interval )
end

function modifier_sniper_take_aim_lua:OnRefresh( kv )
	-- references
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	self:OnIntervalThink()
end

function modifier_sniper_take_aim_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_take_aim_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end
function modifier_sniper_take_aim_lua:GetModifierAttackRangeBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_attack_range
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_take_aim_lua:OnIntervalThink()
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) + math.floor(self:GetParent():GetAgility() * self.agi_multiplier) -- special value
end