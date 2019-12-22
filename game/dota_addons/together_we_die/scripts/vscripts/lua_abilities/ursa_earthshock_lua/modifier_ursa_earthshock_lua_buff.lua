modifier_ursa_earthshock_lua_buff = class({})

--------------------------------------------------------------------------------

function modifier_ursa_earthshock_lua_buff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ursa_earthshock_lua_buff:OnCreated( kv )
end

function modifier_ursa_earthshock_lua_buff:OnRefresh( kv )
end

function modifier_ursa_earthshock_lua_buff:OnDestroy( kv )
	if not IsServer() then return end
	self:GetAbility():ActivateSpellMechanics()
end
