--------------------------------------------------------------------------------
modifier_phantom_lancer_spirit_lance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_lancer_spirit_lance_lua:IsHidden()
	return false
end

function modifier_phantom_lancer_spirit_lance_lua:IsDebuff()
	return true
end

function modifier_phantom_lancer_spirit_lance_lua:IsStunDebuff()
	return false
end

function modifier_phantom_lancer_spirit_lance_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_lancer_spirit_lance_lua:OnCreated( kv )
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
end

function modifier_phantom_lancer_spirit_lance_lua:OnRefresh( kv )
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
end

function modifier_phantom_lancer_spirit_lance_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_lancer_spirit_lance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_phantom_lancer_spirit_lance_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed_pct
end