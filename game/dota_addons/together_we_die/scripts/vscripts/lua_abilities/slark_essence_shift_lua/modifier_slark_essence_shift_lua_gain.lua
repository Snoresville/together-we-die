modifier_slark_essence_shift_lua_gain = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua_gain:IsHidden()
	return false
end

function modifier_slark_essence_shift_lua_gain:IsDebuff()
	return false
end

function modifier_slark_essence_shift_lua_gain:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua_gain:OnCreated( kv )
	-- references
	self.permanent_agi_gain = self:GetAbility():GetSpecialValueFor( "permanent_agi_gain" )
end

function modifier_slark_essence_shift_lua_gain:OnRefresh( kv )
	-- references
	self.permanent_agi_gain = self:GetAbility():GetSpecialValueFor( "permanent_agi_gain" )
end

function modifier_slark_essence_shift_lua_gain:OnDestroy( kv )
end

function modifier_slark_essence_shift_lua_gain:RemoveOnDeath()
	return false
end

function modifier_slark_essence_shift_lua_gain:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_lua_gain:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_slark_essence_shift_lua_gain:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self.permanent_agi_gain
end
