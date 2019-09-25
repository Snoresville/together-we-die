modifier_slardar_bash_of_the_deep_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slardar_bash_of_the_deep_lua_stack:IsHidden()
	return false
end

function modifier_slardar_bash_of_the_deep_lua_stack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slardar_bash_of_the_deep_lua_stack:OnCreated( kv )
	-- references
end

function modifier_slardar_bash_of_the_deep_lua_stack:OnRefresh( kv )
	-- references
	self:IncrementStackCount()
end

function modifier_slardar_bash_of_the_deep_lua_stack:OnDestroy( kv )
end
