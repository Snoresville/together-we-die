modifier_creature_magic_immunity_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_magic_immunity_lua:IsHidden()
	return true
end

function modifier_creature_magic_immunity_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_magic_immunity_lua:OnCreated( kv )
end

function modifier_creature_magic_immunity_lua:OnRefresh( kv )
end

function modifier_creature_magic_immunity_lua:OnDestroy( kv )

end


function modifier_creature_magic_immunity_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_magic_immunity_lua:GetStatusEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_creature_magic_immunity_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end