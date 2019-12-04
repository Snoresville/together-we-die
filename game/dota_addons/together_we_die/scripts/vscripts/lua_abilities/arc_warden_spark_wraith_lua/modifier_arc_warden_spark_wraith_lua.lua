--------------------------------------------------------------------------------
modifier_arc_warden_spark_wraith_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_warden_spark_wraith_lua:IsHidden()
	return false
end

function modifier_arc_warden_spark_wraith_lua:IsDebuff()
	return true
end

function modifier_arc_warden_spark_wraith_lua:IsStunDebuff()
	return false
end

function modifier_arc_warden_spark_wraith_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_arc_warden_spark_wraith_lua:OnCreated( kv )
	self.move_speed_slow_pct = self:GetAbility():GetSpecialValueFor( "move_speed_slow_pct" )
end

function modifier_arc_warden_spark_wraith_lua:OnRefresh( kv )
	self.move_speed_slow_pct = self:GetAbility():GetSpecialValueFor( "move_speed_slow_pct" )
end

function modifier_arc_warden_spark_wraith_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_arc_warden_spark_wraith_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_arc_warden_spark_wraith_lua:GetModifierMoveSpeedBonus_Percentage()
	return -self.move_speed_slow_pct
end