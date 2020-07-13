modifier_lycan_shapeshift_lua_transform = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_shapeshift_lua_transform:IsHidden()
	return true
end

function modifier_lycan_shapeshift_lua_transform:IsDebuff()
	return false
end

function modifier_lycan_shapeshift_lua_transform:IsPurgable()
	return false
end

function modifier_lycan_shapeshift_lua_transform:RemoveOnDeath()
	return true
end

function modifier_lycan_shapeshift_lua_transform:OnDestroy()
	local caster = self:GetAbility():ShapeshiftEffects()
end