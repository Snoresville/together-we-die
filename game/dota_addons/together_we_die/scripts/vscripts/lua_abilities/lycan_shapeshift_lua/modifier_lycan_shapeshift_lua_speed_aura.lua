modifier_lycan_shapeshift_lua_speed_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_shapeshift_lua_speed_aura:IsHidden()
	return false
end

function modifier_lycan_shapeshift_lua_speed_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lycan_shapeshift_lua_speed_aura:OnCreated( kv )
	-- references
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lycan_shapeshift_lua_speed_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}

	return funcs
end

function modifier_lycan_shapeshift_lua_speed_aura:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_lycan_shapeshift_lua_speed_aura:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_lycan_shapeshift_lua_speed_aura:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_lycan_shapeshift_lua_speed_aura:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and self:RollChance( self:GetAbility():GetSpecialValueFor( "crit_chance" ) ) then
		return self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	end
end

function modifier_lycan_shapeshift_lua_speed_aura:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_lycan_shapeshift_lua_speed_aura:GetBonusNightVision()
	return self:GetAbility():GetSpecialValueFor( "bonus_night_vision" )
end