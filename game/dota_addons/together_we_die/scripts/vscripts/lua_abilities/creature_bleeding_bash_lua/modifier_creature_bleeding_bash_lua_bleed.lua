modifier_creature_bleeding_bash_lua_bleed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_bleeding_bash_lua_bleed:IsHidden()
	return false
end

function modifier_creature_bleeding_bash_lua_bleed:IsPurgable()
	return false
end

function modifier_creature_bleeding_bash_lua_bleed:IsDebuff()
	return true
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_bleeding_bash_lua_bleed:OnCreated( kv )
	-- references
	self:SetStackCount(1)
	self.bleed_damage = self:GetAbility():GetSpecialValueFor( "bleed_damage" )
end

function modifier_creature_bleeding_bash_lua_bleed:OnRefresh( kv )
	-- references
	self:IncrementStackCount()
end

function modifier_creature_bleeding_bash_lua_bleed:OnDestroy( kv )
end

--------------------------------------------------------------------------------
function modifier_creature_bleeding_bash_lua_bleed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_bleeding_bash_lua_bleed:GetDisableHealing( params )
	return 1
end

function modifier_creature_bleeding_bash_lua_bleed:GetModifierConstantHealthRegen()
	return -(self.bleed_damage * self:GetStackCount())
end