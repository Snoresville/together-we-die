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
	-- references
	local ability = self:GetAbility()
	local ability_name = ability:GetAbilityName()
	self.player = self:GetParent():GetPlayerID()
	self.original_hero = PlayerResource:GetSelectedHeroEntity(self.player)
	self.original_ability = self.original_hero:FindAbilityByName(ability_name)
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRefresh( kv )
	-- references
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRemoved( kv )
	self.original_ability:DecrementSpawnedIllusionsCount()
end
