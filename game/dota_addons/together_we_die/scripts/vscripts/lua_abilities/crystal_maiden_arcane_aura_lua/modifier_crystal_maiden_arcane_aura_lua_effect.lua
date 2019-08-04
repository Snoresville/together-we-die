modifier_crystal_maiden_arcane_aura_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystal_maiden_arcane_aura_lua_effect:IsHidden()
	return false
end

function modifier_crystal_maiden_arcane_aura_lua_effect:IsDebuff()
	return false
end

function modifier_crystal_maiden_arcane_aura_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_arcane_aura_lua_effect:OnCreated( kv )
	-- references
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" ) -- special value
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" ) -- special value
end

function modifier_crystal_maiden_arcane_aura_lua_effect:OnRefresh( kv )
	-- references
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" ) -- special value
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" ) -- special value
end

function modifier_crystal_maiden_arcane_aura_lua_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_crystal_maiden_arcane_aura_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_BASE_MANA_REGEN,
	}

	return funcs
end
function modifier_crystal_maiden_arcane_aura_lua_effect:GetModifierConstantManaRegen()
	local selfRegen = self.regen_self + (self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_multiplier"))
	local allyRegen = self.regen_ally + (self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_multiplier"))

	if self:GetParent()==self:GetCaster() then 
		return selfRegen
	end
	return allyRegen
end
-- function modifier_crystal_maiden_arcane_aura_lua_effect:GetModifierBaseRegen()
-- 	return 
-- end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_crystal_maiden_arcane_aura_lua_effect:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_crystal_maiden_arcane_aura_lua_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end