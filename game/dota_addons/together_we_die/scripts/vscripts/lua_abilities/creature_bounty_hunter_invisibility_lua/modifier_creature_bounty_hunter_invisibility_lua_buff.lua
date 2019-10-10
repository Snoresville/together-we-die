modifier_creature_bounty_hunter_invisibility_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_bounty_hunter_invisibility_lua_buff:IsHidden()
	return false
end

function modifier_creature_bounty_hunter_invisibility_lua_buff:IsDebuff()
	return false
end

function modifier_creature_bounty_hunter_invisibility_lua_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_bounty_hunter_invisibility_lua_buff:OnCreated( kv )

end

function modifier_creature_bounty_hunter_invisibility_lua_buff:OnRefresh( kv )

end

function modifier_creature_bounty_hunter_invisibility_lua_buff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_bounty_hunter_invisibility_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}

	return funcs
end

function modifier_creature_bounty_hunter_invisibility_lua_buff:GetModifierInvisibilityLevel()
	return 1
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_creature_bounty_hunter_invisibility_lua_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}

	return state
end