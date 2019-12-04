arc_warden_spark_wraith_lua = class({})
LinkLuaModifier( "modifier_arc_warden_spark_wraith_lua_thinker", "lua_abilities/arc_warden_spark_wraith_lua/modifier_arc_warden_spark_wraith_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_lua", "lua_abilities/arc_warden_spark_wraith_lua/modifier_arc_warden_spark_wraith_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function arc_warden_spark_wraith_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function arc_warden_spark_wraith_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local point = self:GetCursorPosition()

	-- create modifier thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_arc_warden_spark_wraith_lua_thinker",
		{ duration = duration },
		point,
		caster:GetTeamNumber(),
		false
	)

	EmitSoundOnLocationWithCaster( point, "Hero_ArcWarden.SparkWraith.Cast", self:GetCaster() )
end

-- Projectile
function arc_warden_spark_wraith_lua:OnProjectileHit( target, location )
	if not target then return end

	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor( "spark_damage" ) + self:GetSpecialValueFor( "agi_multiplier" ) * caster:GetAgility()
	local duration = self:GetSpecialValueFor( "ministun_duration" )

	-- precache damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	-- mini stun
	target:Interrupt()
	-- Add slow
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_arc_warden_spark_wraith_lua", -- modifier name
		{ duration = duration } -- kv
	)

	self:PlayEffects1( target )
end
--------------------------------------------------------------------------------
function arc_warden_spark_wraith_lua:PlayEffects1( target )
	-- Get Resources
	local sound_cast = "Hero_ArcWarden.SparkWraith.Damage"

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------