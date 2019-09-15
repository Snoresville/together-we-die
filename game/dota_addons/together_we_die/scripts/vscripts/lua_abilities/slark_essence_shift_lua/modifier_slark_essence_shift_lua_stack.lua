modifier_slark_essence_shift_lua_stack = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua_stack:IsHidden()
	return false
end

function modifier_slark_essence_shift_lua_stack:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua_stack:OnCreated( kv )
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
	-- Add stack
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_lua_stack:OnRefresh( kv )
	self.agi_gain = self:GetAbility():GetSpecialValueFor( "agi_gain" )
	-- Add stack
	self:IncrementStackCount()
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_lua_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_slark_essence_shift_lua_stack:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self.agi_gain
end