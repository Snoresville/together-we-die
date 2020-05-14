modifier_riki_smoke_screen_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_smoke_screen_lua_debuff:IsHidden()
	return false
end

function modifier_riki_smoke_screen_lua_debuff:IsDebuff()
	return true
end

function modifier_riki_smoke_screen_lua_debuff:IsStunDebuff()
	return false
end

function modifier_riki_smoke_screen_lua_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_smoke_screen_lua_debuff:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" ) -- special value
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) -- special value
	self.armor_agi_multiplier = self:GetAbility():GetSpecialValueFor( "armor_agi_multiplier" ) -- special value
end

function modifier_riki_smoke_screen_lua_debuff:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" ) -- special value
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) -- special value
	self.armor_agi_multiplier = self:GetAbility():GetSpecialValueFor( "armor_agi_multiplier" ) -- special value
end

function modifier_riki_smoke_screen_lua_debuff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_riki_smoke_screen_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_riki_smoke_screen_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_riki_smoke_screen_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction - math.floor(self:GetCaster():GetAgility() * self.armor_agi_multiplier)
end

function modifier_riki_smoke_screen_lua_debuff:GetModifierMiss_Percentage()
	return self.miss_rate
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_riki_smoke_screen_lua_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_riki_smoke_screen_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
