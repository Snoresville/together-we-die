modifier_invoker_forge_spirit_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_forge_spirit_lua:IsHidden()
	return true
end

function modifier_invoker_forge_spirit_lua:IsDebuff()
	return false
end

function modifier_invoker_forge_spirit_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_forge_spirit_lua:OnCreated( kv )
	self.attack_range = kv.attack_range
end

function modifier_invoker_forge_spirit_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_invoker_forge_spirit_lua:OnRemoved()
end

function modifier_invoker_forge_spirit_lua:OnDestroy()
	if not IsServer() then return end
	self:GetParent():ForceKill( false )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_forge_spirit_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_invoker_forge_spirit_lua:GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_invoker_forge_spirit_lua:GetUnitLifetimeFraction( params )
return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end