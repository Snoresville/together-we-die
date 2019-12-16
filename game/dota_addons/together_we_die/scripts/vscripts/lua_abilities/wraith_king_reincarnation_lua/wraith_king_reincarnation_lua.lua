wraith_king_reincarnation_lua = class({})
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua", "lua_abilities/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua_debuff", "lua_abilities/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
function wraith_king_reincarnation_lua:GetManaCost( iLevel )
	return self.BaseClass.GetManaCost( self, iLevel ) + math.floor( self:GetCaster():GetStrength() * self:GetSpecialValueFor( "mana_str_multiplier" ) )
end
--------------------------------------------------------------------------------
function wraith_king_reincarnation_lua:GetCooldown( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, iLevel )
end
--------------------------------------------------------------------------------
-- Passive Modifier
function wraith_king_reincarnation_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_reincarnation_lua"
end