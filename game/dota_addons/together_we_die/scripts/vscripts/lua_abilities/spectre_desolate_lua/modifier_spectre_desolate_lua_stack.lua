modifier_spectre_desolate_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_desolate_lua_stack:IsHidden()
	return false
end

function modifier_spectre_desolate_lua_stack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spectre_desolate_lua_stack:OnCreated( kv )
	-- references
	self:SetStackCount(1)
end

function modifier_spectre_desolate_lua_stack:OnRefresh( kv )
	-- references
	self:IncrementStackCount()
end

function modifier_spectre_desolate_lua_stack:OnDestroy( kv )
end
