modifier_phantom_lancer_juxtapose_illusion_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_lancer_juxtapose_illusion_lua:IsHidden()
	return true
end

function modifier_phantom_lancer_juxtapose_illusion_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_lancer_juxtapose_illusion_lua:OnCreated( kv )
	if not IsServer() then return end
	-- references
	local ability = self:GetAbility()
	local ability_name = ability:GetAbilityName()
	local original_hero = self:GetParent():GetOwner()
	self.original_ability = original_hero:FindAbilityByName( ability_name )
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRefresh( kv )
	-- references
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRemoved( kv )
	if not IsServer() then return end
	self.original_ability:DecrementSpawnedIllusionsCount()
end
