--------------------------------------------------------------------------------
modifier_arc_warden_tempest_double_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_warden_tempest_double_lua:IsHidden()
	return true
end

function modifier_arc_warden_tempest_double_lua:IsDebuff()
	return true
end

function modifier_arc_warden_tempest_double_lua:IsStunDebuff()
	return false
end

function modifier_arc_warden_tempest_double_lua:IsPurgable()
	return false
end

function modifier_arc_warden_tempest_double_lua:OnDestroy()
	if IsServer() then
		self:GetParent():MakeIllusion()
		self:GetParent():ForceKill( false )
	end
end

function modifier_arc_warden_tempest_double_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_arc_warden_tempest_double_lua:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end