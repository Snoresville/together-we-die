modifier_lycan_summon_wolves_lua = class({})

--------------------------------------------------------------------------------
function modifier_lycan_summon_wolves_lua:OnCreated(kv)
	self.masteryCount = self:GetAbility():GetMasteryStack()
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
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_LIFETIME_FRACTION
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lycan_summon_wolves_lua:OnDeath(event)
    if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() or event.unit:IsIllusion() then
        return
    end
	
	local unit = self:GetParent()
	local owner = unit:GetOwner()
	
	if unit == event.attacker and unit ~= event.unit and owner:HasAbility( "lycan_summon_wolves_lua" ) then
		self:GetAbility():IncreaseMastery()
	end
end

function modifier_lycan_summon_wolves_lua:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
