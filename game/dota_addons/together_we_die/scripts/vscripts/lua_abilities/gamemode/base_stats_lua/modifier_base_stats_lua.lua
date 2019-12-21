modifier_base_stats_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_base_stats_lua:IsHidden()
	return true
end

function modifier_base_stats_lua:IsDebuff()
	return false
end

function modifier_base_stats_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_base_stats_lua:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.str_buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_strength_lua", {})
	self.agi_buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_agility_lua", {})
	self.int_buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_intelligence_lua", {})

	local interval = 0.1
	-- start interval
	self:OnIntervalThink()
	self:StartIntervalThink( interval )
end

function modifier_base_stats_lua:OnRefresh( kv )
	-- references
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_base_stats_lua:OnIntervalThink()
	local strength = self:GetParent():GetStrength()
	local agility = self:GetParent():GetAgility()
	local intelligence = self:GetParent():GetIntellect()

	self.str_buff:SetStackCount(strength)
	self.agi_buff:SetStackCount(agility)
	self.int_buff:SetStackCount(intelligence)
end