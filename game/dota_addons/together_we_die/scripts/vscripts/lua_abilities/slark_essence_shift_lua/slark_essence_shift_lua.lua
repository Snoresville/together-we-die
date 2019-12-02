slark_essence_shift_lua = class({})
LinkLuaModifier( "modifier_slark_essence_shift_lua", "lua_abilities/slark_essence_shift_lua/modifier_slark_essence_shift_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_lua_debuff", "lua_abilities/slark_essence_shift_lua/modifier_slark_essence_shift_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_lua_stack", "lua_abilities/slark_essence_shift_lua/modifier_slark_essence_shift_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_lua_gain", "lua_abilities/slark_essence_shift_lua/modifier_slark_essence_shift_lua_gain", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function slark_essence_shift_lua:GetIntrinsicModifierName()
	return "modifier_slark_essence_shift_lua"
end

function slark_essence_shift_lua:GetEssenceShiftKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end

function slark_essence_shift_lua:IncrementEssenceShiftKills()
	self.nKills = self:GetEssenceShiftKills() + 1
end

function slark_essence_shift_lua:IncrementHeroKills()
	self.nKills = self:GetEssenceShiftKills() + 10
end