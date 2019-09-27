modifier_lion_finger_of_death_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lion_finger_of_death_lua_stack:IsHidden()
	return false
end

function modifier_lion_finger_of_death_lua_stack:IsPurgable()
	return false
end

function modifier_lion_finger_of_death_lua_stack:RemoveOnDeath()
	return false
end

function modifier_lion_finger_of_death_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lion_finger_of_death_lua_stack:OnCreated( kv )
	-- references
end

function modifier_lion_finger_of_death_lua_stack:OnRefresh( kv )
	self:IncrementStackCount()
end