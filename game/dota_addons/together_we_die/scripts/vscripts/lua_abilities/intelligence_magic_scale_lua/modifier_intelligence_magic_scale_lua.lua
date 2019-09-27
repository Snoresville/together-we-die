modifier_intelligence_magic_scale_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_intelligence_magic_scale_lua:IsHidden()
	return true
end

function modifier_intelligence_magic_scale_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_intelligence_magic_scale_lua:OnCreated( kv )
	-- references
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )

	local interval = 1
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_intelligence_magic_scale_lua:OnRefresh( kv )
	-- references
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )

	self:OnIntervalThink()
end

function modifier_intelligence_magic_scale_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_intelligence_magic_scale_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_intelligence_magic_scale_lua:GetModifierSpellAmplify_Percentage( params )
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_magic_pct
	end
end

function modifier_intelligence_magic_scale_lua:OnIntervalThink()
	self.bonus_magic_pct = math.floor(self:GetParent():GetIntellect() * self.int_multiplier) -- special value
end