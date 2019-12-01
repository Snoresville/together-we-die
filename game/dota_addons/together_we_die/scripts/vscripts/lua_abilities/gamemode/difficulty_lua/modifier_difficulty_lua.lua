modifier_difficulty_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_difficulty_lua:IsHidden()
	return true
end

function modifier_difficulty_lua:IsDebuff()
	return false
end

function modifier_difficulty_lua:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_difficulty_lua:IsAura()
	return true
end

function modifier_difficulty_lua:GetModifierAura()
	return "modifier_difficulty_lua_effect"
end

function modifier_difficulty_lua:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end

function modifier_difficulty_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_difficulty_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Prevent Ancient Death
function modifier_difficulty_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
end

function modifier_difficulty_lua:GetMinHealth()
	return 1
end