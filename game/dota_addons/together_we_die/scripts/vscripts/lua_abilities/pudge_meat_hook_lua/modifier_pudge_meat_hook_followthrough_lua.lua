modifier_pudge_meat_hook_followthrough_lua = class({})

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_followthrough_lua:IsHidden()
	return true
end

function modifier_pudge_meat_hook_followthrough_lua:IsDebuff()
	return true
end

function modifier_pudge_meat_hook_followthrough_lua:IsStunDebuff()
	return true
end

function modifier_pudge_meat_hook_followthrough_lua:IsPurgable()
	return true
end

function modifier_pudge_meat_hook_followthrough_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_followthrough_lua:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
