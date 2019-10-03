invoker_tornado_lua = class({})

LinkLuaModifier( "modifier_invoker_tornado_lua", "lua_abilities/invoker_tornado_lua/modifier_invoker_tornado_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_invoker_tornado_lua_thinker", "lua_abilities/invoker_tornado_lua/modifier_invoker_tornado_lua_thinker", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Ability Start
function invoker_tornado_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_invoker_tornado_lua_thinker", -- modifier name
		{}, -- kv
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end
--------------------------------------------------------------------------------
-- Projectile
function invoker_tornado_lua:OnStolen( hAbility )
	self.orbs = hAbility.orbs
end

function invoker_tornado_lua:GetOrbSpecialValueFor( key_name, orb_name )
	if not IsServer() then return 0 end
	if not self.orbs[orb_name] then return 0 end
	return self:GetLevelSpecialValueFor( key_name, self.orbs[orb_name] )
end