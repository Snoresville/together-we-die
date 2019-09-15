modifier_slark_essence_shift_lua_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_lua_debuff:IsHidden()
	return false
end

function modifier_slark_essence_shift_lua_debuff:IsDebuff()
	return true
end

function modifier_slark_essence_shift_lua_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_lua_debuff:OnCreated( kv )
	-- references
	self.armor_loss = self:GetAbility():GetSpecialValueFor( "armor_loss" )
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_lua_debuff:OnRefresh( kv )
	-- references
	self.armor_loss = self:GetAbility():GetSpecialValueFor( "armor_loss" )
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_lua_debuff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_slark_essence_shift_lua_debuff:GetModifierPhysicalArmorBonus()
	local MAX_ARMOR_REDUCTION = -150
	return math.max(self:GetStackCount() * -self.armor_loss, MAX_ARMOR_REDUCTION)
end