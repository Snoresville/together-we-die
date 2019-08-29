bristleback_warpath_lua = class({})
LinkLuaModifier( "modifier_bristleback_warpath_lua", "lua_abilities/bristleback_warpath_lua/modifier_bristleback_warpath_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_warpath_stack_lua", "lua_abilities/bristleback_warpath_lua/modifier_bristleback_warpath_stack_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function bristleback_warpath_lua:GetIntrinsicModifierName()
	return "modifier_bristleback_warpath_lua"
end

--------------------------------------------------------------------------------
function bristleback_warpath_lua:GetStackCount()
	if self.stack_count == nil then
		self.stack_count = 0
	end
	return self.stack_count
end

function bristleback_warpath_lua:IncrementStackCount()
	self.stack_count = self:GetStackCount() + 1
end

function bristleback_warpath_lua:DecrementStackCount()
	self.stack_count = self:GetStackCount() - 1
end