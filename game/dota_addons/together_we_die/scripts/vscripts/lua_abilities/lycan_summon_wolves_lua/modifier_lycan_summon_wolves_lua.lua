modifier_lycan_summon_wolves_lua = class({})

--------------------------------------------------------------------------------
function modifier_lycan_summon_wolves_lua:OnCreated(kv)
end
--------------------------------------------------------------------------------

function modifier_lycan_summon_wolves_lua:IsDebuff()
	return true
end

function modifier_lycan_summon_wolves_lua:IsHidden()
	return true
end

function modifier_lycan_summon_wolves_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_summon_wolves_lua:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_summon_wolves_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lycan_summon_wolves_lua:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
