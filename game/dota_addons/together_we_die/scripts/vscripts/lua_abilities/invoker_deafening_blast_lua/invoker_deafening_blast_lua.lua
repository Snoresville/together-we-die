invoker_deafening_blast_lua = class({})

LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_disarm_lua", "lua_abilities/generic/modifier_generic_disarm_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Ability Start
function invoker_deafening_blast_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
	local projectile_distance = self:GetSpecialValueFor("travel_distance")
	local projectile_speed = self:GetSpecialValueFor("travel_speed")
	local projectile_start_radius = self:GetSpecialValueFor("radius_start")
	local projectile_end_radius = self:GetSpecialValueFor("radius_end")
	local projectile_direction = (point-caster:GetOrigin()):Normalized()

	local info = {
    	Source = caster,
		Ability = self,
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	
    	EffectName = projectile_name,
    	fDistance = projectile_distance,
    	fStartRadius = projectile_start_radius,
    	fEndRadius = projectile_end_radius,
    	bHasFrontalCone = true,
		vVelocity = projectile_direction * projectile_speed,
    	
		bDeleteOnHit = false,
    	bReplaceExisting = false,
    	
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Invoker.DeafeningBlast"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
function invoker_deafening_blast_lua:OnProjectileHit( target, location )
	if not target or target:IsNull() or target == null or not target:IsAlive() then return end

	local damage = self:GetOrbSpecialValueFor( "damage", "e" ) + self:GetCaster():GetIntellect() * self:GetOrbSpecialValueFor( "int_multiplier", "e")
	local knockback_distance = self:GetOrbSpecialValueFor( "knockback_distance", "q" )
	local knockback_duration = self:GetOrbSpecialValueFor( "knockback_duration", "q" )
	local disarm_duration = self:GetOrbSpecialValueFor( "disarm_duration", "w" )

	-- Apply Damage	 
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
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
			duration = knockback_duration,
			distance = knockback_distance,
			height = 20,
			direction_x = enemyOrigin.x - location.x,
			direction_y = enemyOrigin.y - location.y,
		} -- kv
	)

	-- disarm
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_disarm_lua", -- modifier name
		{
			duration = disarm_duration,
		}
	)
end
