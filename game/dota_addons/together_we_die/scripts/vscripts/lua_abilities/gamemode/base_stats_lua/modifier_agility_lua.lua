modifier_agility_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_agility_lua:IsHidden()
	return true
end

function modifier_agility_lua:IsDebuff()
	return false
end

function modifier_agility_lua:IsPurgable()
	return false
end

function modifier_agility_lua:RemoveOnDeath()
	return false
end

function modifier_agility_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end


--------------------------------------------------------------------------------
-- Initializations
function modifier_agility_lua:OnCreated( kv )
	-- references
end

function modifier_agility_lua:OnRefresh( kv )
	-- references
end