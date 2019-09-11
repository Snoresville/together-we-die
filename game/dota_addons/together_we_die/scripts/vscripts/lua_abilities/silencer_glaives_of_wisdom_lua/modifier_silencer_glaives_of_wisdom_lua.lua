-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_silencer_glaives_of_wisdom_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_lua:IsHidden()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua:IsDebuff()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_silencer_glaives_of_wisdom_lua:OnCreated( kv )
	self.glaives_buff_amount = self:GetAbility():GetSpecialValueFor( "glaives_buff_amount" )

	if not IsServer() then return end

	-- create generic orb effect
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_orb_effect_lua", -- modifier name
		{  } -- kv
	)
end

function modifier_silencer_glaives_of_wisdom_lua:OnRefresh( kv )
	self.glaives_buff_amount = self:GetAbility():GetSpecialValueFor( "glaives_buff_amount" )

	if not IsServer() then return end
end

function modifier_silencer_glaives_of_wisdom_lua:OnRemoved()
end

function modifier_silencer_glaives_of_wisdom_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_silencer_glaives_of_wisdom_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_silencer_glaives_of_wisdom_lua:OnDeath( event )
	if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() then
		return
	end

	if event.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsAlive() and event.attacker == self:GetParent() then
		self:GetAbility():IncrementGlaivesKills()

		self:SetStackCount( self:GetAbility():GetGlaivesKills() )
		self:GetParent():CalculateStatBonus()

		-- overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_MANA_ADD,
			self:GetParent(),
			self.glaives_buff_amount,
			nil
		)
	end
end

function modifier_silencer_glaives_of_wisdom_lua:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self.glaives_buff_amount
end
