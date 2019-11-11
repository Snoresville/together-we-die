wraith_king_wraithfire_blast_lua = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_wraithfire_blast_lua_slow", "lua_abilities/wraith_king_wraithfire_blast_lua/modifier_wraith_king_wraithfire_blast_lua_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function wraith_king_wraithfire_blast_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function wraith_king_wraithfire_blast_lua:OnSpellStart()
	-- get references
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local projectile_speed = self:GetSpecialValueFor("blast_speed")
	local projectile_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"

	local radius = self:GetSpecialValueFor( "radius" )

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- create tracking projectile
		local info = {
			EffectName = projectile_name,
			Ability = self,
			iMoveSpeed = projectile_speed,
			Source = caster,
			Target = enemy,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
		ProjectileManager:CreateTrackingProjectile( info )
	end

	self:PlayEffects1()
end

function wraith_king_wraithfire_blast_lua:OnProjectileHit( hTarget, vLocation )
	-- check target
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsMagicImmune() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" )
		local stun_damage = self:GetAbilityDamage() + (self:GetCaster():GetStrength() * self:GetSpecialValueFor( "str_multiplier" ))
		local dot_duration = self:GetSpecialValueFor( "blast_dot_duration" )

		-- apply initial damage
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = stun_damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
		ApplyDamage( damage )

		-- apply stun debuff
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
		
		-- apply slow debuff
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_wraith_king_wraithfire_blast_lua_slow", { duration = dot_duration } )

		self:PlayEffects2( hTarget )
	end

	return true
end

function wraith_king_wraithfire_blast_lua:PlayEffects1()
	-- get resource
	local sound_cast = "Hero_SkeletonKing.Hellfire_Blast"

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function wraith_king_wraithfire_blast_lua:PlayEffects2( target )
	-- get resource
	local sound_impact = "Hero_SkeletonKing.Hellfire_BlastImpact"

	-- play sound
	EmitSoundOn( sound_impact, target )
end