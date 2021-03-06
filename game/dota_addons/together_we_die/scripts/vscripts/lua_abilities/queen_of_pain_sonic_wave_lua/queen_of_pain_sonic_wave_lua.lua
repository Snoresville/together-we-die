queen_of_pain_sonic_wave_lua = class({})

LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Ability Start
function queen_of_pain_sonic_wave_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
	local projectile_distance = self:GetSpecialValueFor("distance")
	local projectile_speed = self:GetSpecialValueFor("speed")
	local projectile_start_radius = self:GetSpecialValueFor("starting_aoe")
	local projectile_end_radius = self:GetSpecialValueFor("final_aoe")
	local projectile_direction = (point-caster:GetOrigin()):Normalized()

	local info = {
    	Source = caster,
		Ability = self,
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	
    	-- EffectName = projectile_name,
    	fDistance = projectile_distance,
    	fStartRadius = projectile_start_radius,
    	fEndRadius = projectile_end_radius,
    	bHasFrontalCone = false,
		vVelocity = projectile_direction * projectile_speed,
    	
		bDeleteOnHit = false,
    	bReplaceExisting = false,
    	-- fExpireTime = GameRules:GetGameTime() + 10.0,
    	
    	iUnitTargetTeam = self:GetAbilityTargetTeam(),
    	iUnitTargetFlags = self:GetAbilityTargetFlags(),
    	iUnitTargetType = self:GetAbilityTargetType(),
		
		bProvidesVision = false,
	}
	self:PlayProjectile( info )
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_QueenOfPain.SonicWave"
	EmitSoundOn( sound_cast, caster )
end

function queen_of_pain_sonic_wave_lua:GetCooldown( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	else
		return self:GetSpecialValueFor("cooldown")
	end
end

--------------------------------------------------------------------------------
-- Projectile
function queen_of_pain_sonic_wave_lua:OnProjectileHit( target, location )
	if not target or target:IsNull() or target == null or not target:IsAlive() then return end

	local screamDamage = self:GetCaster():GetIntellect() * self:GetSpecialValueFor( "int_multiplier" )
	if self:GetCaster():HasScepter() then
		screamDamage = self:GetSpecialValueFor("damage") + screamDamage
	else
		screamDamage = self:GetSpecialValueFor("damage_scepter") + screamDamage
	end

	-- Apply Damage	 
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = screamDamage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	local enemyOrigin = target:GetOrigin()

	-- knockback
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_knockback_lua", -- modifier name
		{
			duration = 1.75,
			distance = self:GetSpecialValueFor( "knockback_distance" ),
			height = 30,
			direction_x = enemyOrigin.x - location.x,
			direction_y = enemyOrigin.y - location.y,
		} -- kv
	)
end

function queen_of_pain_sonic_wave_lua:PlayProjectile( info )
	-- get resources
	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"

	-- create particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:SetParticleControl( effect_cast, 1, info.vVelocity )

	ParticleManager:ReleaseParticleIndex( effect_cast )
end