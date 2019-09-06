lion_earth_spike_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- AOE Radius
function lion_earth_spike_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
--------------------------------------------------------------------------------
-- Ability Start
function lion_earth_spike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- load data
	if target then
		point = target:GetOrigin()
	end

	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local projectile_name = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf"
	local projectile_radius = self:GetSpecialValueFor( "width" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local caster_abs_origin = caster:GetAbsOrigin()
	for _,enemy in pairs(targets) do
		point = enemy:GetOrigin()
		local projectile_distance = self:GetCastRange( point, enemy )
		local projectile_direction = (point-caster:GetOrigin()):Normalized()
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = caster_abs_origin,
			
			bDeleteOnHit = false,
			
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			
			EffectName = projectile_name,
			fDistance = projectile_distance,
			fStartRadius = projectile_radius,
			fEndRadius = projectile_radius,
			vVelocity = projectile_direction * projectile_speed,
		}
		ProjectileManager:CreateLinearProjectile(info)
	end

	-- play effects
	local sound_cast = "Hero_Lion.Impale"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
function lion_earth_spike_lua:OnProjectileHit( target, location )
	if not target then return end
	if target:TriggerSpellAbsorb( self ) then return end

	local stun = self:GetSpecialValueFor( "duration" )
	local damage = self:GetAbilityDamage() + (self:GetCaster():GetIntellect() * self:GetSpecialValueFor("int_multiplier"))

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- stun
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = stun } -- kv
	)

	-- knockback
	local knockback = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_knockback_lua", -- modifier name
		{
			duration = 0.5,
			height = 350,
		} -- kv
	)
	local callback = function()
		-- damage on landed
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		-- play effects
		local sound_cast = "Hero_Lion.ImpaleTargetLand"
		EmitSoundOn( sound_cast, target )
	end
	knockback:SetEndCallback( callback )

	-- play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function lion_earth_spike_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf"
	local sound_cast = "Hero_Lion.ImpaleHitTarget"

	-- Get Data

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end