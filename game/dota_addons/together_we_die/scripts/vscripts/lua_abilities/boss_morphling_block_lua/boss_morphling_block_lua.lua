boss_morphling_block_lua = class({})
LinkLuaModifier( "modifier_boss_morphling_block_lua", "lua_abilities/boss_morphling_block_lua/modifier_boss_morphling_block_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_morphling_block_str_lua", "lua_abilities/boss_morphling_block_lua/modifier_boss_morphling_block_str_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_morphling_block_agi_lua", "lua_abilities/boss_morphling_block_lua/modifier_boss_morphling_block_agi_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_morphling_block_int_lua", "lua_abilities/boss_morphling_block_lua/modifier_boss_morphling_block_int_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function boss_morphling_block_lua:GetIntrinsicModifierName()
	return "modifier_boss_morphling_block_lua"
end