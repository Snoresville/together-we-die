arc_warden_spark_wraith_lua = class({})
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
		"modifier_arc_warden_spark_wraith_lua",
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

	local damage = self:GetSpecialValueFor( "spark_damage" ) + self:GetSpecialValueFor( "agi_multiplier" ) * self:GetCaster():GetAgility()

	-- precache damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	self:PlayEffects1( target )
end
--------------------------------------------------------------------------------
function arc_warden_spark_wraith_lua:PlayEffects1( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj_elec_hit.vpcf"
	local sound_cast = "Hero_ArcWarden.SparkWraith.Damage"

	-- Create Sound
	EmitSoundOn( sound_cast, target )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------------------------