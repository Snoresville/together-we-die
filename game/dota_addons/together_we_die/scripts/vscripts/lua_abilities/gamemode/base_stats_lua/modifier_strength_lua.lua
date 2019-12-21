modifier_strength_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_strength_lua:IsHidden()
	return true
end

function modifier_strength_lua:IsDebuff()
	return false
end

function modifier_strength_lua:IsPurgable()
	return false
end

function modifier_strength_lua:RemoveOnDeath()
	return false
end

function modifier_strength_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_strength_lua:OnCreated( kv )
	-- references
end

function modifier_strength_lua:OnRefresh( kv )
	-- references
end
