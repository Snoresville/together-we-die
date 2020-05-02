modifier_card_points_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_card_points_lua:IsHidden()
	return false
end

function modifier_card_points_lua:IsDebuff()
	return false
end

function modifier_card_points_lua:IsPurgable()
	return false
end

function modifier_card_points_lua:IsPermanent()
	return true
end

function modifier_card_points_lua:RemoveOnDeath()
	return false
end

function modifier_card_points_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_card_points_lua:OnCreated( kv )
	-- references
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetCP() )
	end
end

function modifier_card_points_lua:OnRefresh( kv )
	-- references
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetCP() )
	end
end
