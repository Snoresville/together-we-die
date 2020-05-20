tinker_heat_seeking_missile_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function tinker_heat_seeking_missile_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local int_multiplier = self:GetSpecialValueFor("int_multiplier")
	-- Talent Tree
	local special_heat_seeking_int_multiplier_lua = self:GetCaster():FindAbilityByName("special_heat_seeking_int_multiplier_lua")
	if special_heat_seeking_int_multiplier_lua and special_heat_seeking_int_multiplier_lua:GetLevel() ~= 0 then
		int_multiplier = int_multiplier + special_heat_seeking_int_multiplier_lua:GetSpecialValueFor("value")
	end
	local damage = self:GetSpecialValueFor("damage") + (caster:GetIntellect() * int_multiplier)
	local targets = self:GetSpecialValueFor("targets")
	if caster:HasScepter() then
		targets = self:GetSpecialValueFor("targets_scepter")
	end
	local stun_duration = 0
	-- Talent Tree
	local special_heat_seeking_mini_stun_lua = self:GetCaster():FindAbilityByName("special_heat_seeking_mini_stun_lua")
	if special_heat_seeking_mini_stun_lua and special_heat_seeking_mini_stun_lua:GetLevel() ~= 0 then
		stun_duration = special_heat_seeking_mini_stun_lua:GetSpecialValueFor("value")
	end
	local projectile_name = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
	local projectile_speed = self:GetSpecialValueFor("speed")

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self:GetAbilityTargetTeam(),	-- int, team filter
		self:GetAbilityTargetType(),	-- int, type filter
		self:GetAbilityTargetFlags(),	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- create projectile for each enemy
	local info = {
		Source = caster,
		-- Target = target,
		Ability = self,
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		ExtraData = {
			damage = damage,
			stun_duration = stun_duration,
		}
	}
	for i=1,math.min(targets,#enemies) do
		info.Target = enemies[i]
		ProjectileManager:CreateTrackingProjectile( info )
	end

	-- effects
	if #enemies<1 then
		self:PlayEffects2()
	else
		local sound_cast = "Hero_Tinker.Heat-Seeking_Missile"
		EmitSoundOn( sound_cast, caster )
	end
end
--------------------------------------------------------------------------------
-- Projectile
function tinker_heat_seeking_missile_lua:OnProjectileHit_ExtraData( target, location, extraData )
	-- Apply damage
	local damage = {
		victim = target,
		attacker = self:GetCaster(),
		damage = extraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	ApplyDamage( damage )

	if extraData.stun_duration ~= 0 then
		target:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = extraData.stun_duration } -- kv
		)
	end

	-- effects
	self:PlayEffects1( target )
end

--------------------------------------------------------------------------------
-- Effects
function tinker_heat_seeking_missile_lua:PlayEffects1( target )
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local sound_cast = "Hero_Tinker.Heat-Seeking_Missile.Impact"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end

function tinker_heat_seeking_missile_lua:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf"
	local sound_cast = "Hero_Tinker.Heat-Seeking_Missile_Dud"

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_attack3" )~=0 then attach = "attach_attack3" end
	local point = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( attach ) )

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end