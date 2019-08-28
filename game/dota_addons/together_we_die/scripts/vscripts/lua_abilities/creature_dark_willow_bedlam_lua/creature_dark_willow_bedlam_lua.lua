-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
creature_dark_willow_bedlam_lua = class({})
LinkLuaModifier( "modifier_wisp_ambient", "lua_abilities/creature_dark_willow_bedlam_lua/modifier_wisp_ambient", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_dark_willow_bedlam_lua", "lua_abilities/creature_dark_willow_bedlam_lua/modifier_creature_dark_willow_bedlam_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_dark_willow_bedlam_lua_attack", "lua_abilities/creature_dark_willow_bedlam_lua/modifier_creature_dark_willow_bedlam_lua_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_dark_willow_bedlam_debuff_lua", "lua_abilities/creature_dark_willow_bedlam_lua/modifier_creature_dark_willow_bedlam_debuff_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- Passive Modifier
function creature_dark_willow_bedlam_lua:GetIntrinsicModifierName()
	return "modifier_creature_dark_willow_bedlam_lua"
end

--------------------------------------------------------------------------------
-- Projectile
function creature_dark_willow_bedlam_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- destroy effect projectile
	local effect_cast = ExtraData.effect
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if not target then return end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = ExtraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_creature_dark_willow_bedlam_debuff_lua", -- modifier name
		{ duration = self:GetSpecialValueFor( "bedlam_debuff_duration" ) } -- kv
	)
end