--------------------------------------------------------------------------------
drow_ranger_multishot_lua = class({})
LinkLuaModifier( "modifier_drow_ranger_multishot_lua", "lua_abilities/drow_ranger_multishot_lua/modifier_drow_ranger_multishot_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function drow_ranger_multishot_lua:GetIntrinsicModifierName()
	return "modifier_drow_ranger_multishot_lua"
end

--------------------------------------------------------------------------------
-- Projectile
function drow_ranger_multishot_lua:OnProjectileHit( target, location )
	if not target then return end

	-- perform attack
	self.multi_shot_attack = true
	self:GetCaster():PerformAttack(
		target, -- hTarget
		false, -- bUseCastAttackOrb
		false, -- bProcessProcs
		true, -- bSkipCooldown
		false, -- bIgnoreInvis
		false, -- bUseProjectile
		false, -- bFakeAttack
		false -- bNeverMiss
	)
	self.multi_shot_attack = false
end