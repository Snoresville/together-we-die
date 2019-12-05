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
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRefresh( kv )
	-- references
end

function modifier_phantom_lancer_juxtapose_illusion_lua:OnRemoved( kv )
	if not IsServer() then return end
	self:GetAbility():DecrementSpawnedIllusionsCount()
end
