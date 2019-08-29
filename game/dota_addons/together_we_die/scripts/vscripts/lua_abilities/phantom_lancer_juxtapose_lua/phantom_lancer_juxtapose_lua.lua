phantom_lancer_juxtapose_lua = class({})
LinkLuaModifier( "modifier_phantom_lancer_juxtapose_lua", "lua_abilities/phantom_lancer_juxtapose_lua/modifier_phantom_lancer_juxtapose_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_lancer_juxtapose_illusion_lua", "lua_abilities/phantom_lancer_juxtapose_lua/modifier_phantom_lancer_juxtapose_illusion_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function phantom_lancer_juxtapose_lua:GetIntrinsicModifierName()
	return "modifier_phantom_lancer_juxtapose_lua"
end

function phantom_lancer_juxtapose_lua:GetSpawnedIllusionsCount()
	if self.spawned_illusions_count == nil then
		self.spawned_illusions_count = 0
	end
	return self.spawned_illusions_count
end

function phantom_lancer_juxtapose_lua:IncrementSpawnedIllusionsCount()
	self.spawned_illusions_count = self:GetSpawnedIllusionsCount() + 1
end

function phantom_lancer_juxtapose_lua:DecrementSpawnedIllusionsCount()
	self.spawned_illusions_count = self:GetSpawnedIllusionsCount() - 1
end