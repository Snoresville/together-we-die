modifier_intelligence_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_intelligence_lua:IsHidden()
	return true
end

function modifier_intelligence_lua:IsDebuff()
	return false
end

function modifier_intelligence_lua:IsPurgable()
	return false
end

function modifier_intelligence_lua:RemoveOnDeath()
	return false
end

function modifier_intelligence_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end


--------------------------------------------------------------------------------
-- Initializations
function modifier_intelligence_lua:OnCreated( kv )
	-- references
end

function modifier_intelligence_lua:OnRefresh( kv )
	-- references
end
