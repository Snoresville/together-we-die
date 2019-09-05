phantom_assassin_stifling_dagger_lua = class({})
LinkLuaModifier( "modifier_phantom_assassin_stifling_dagger_lua", "lua_abilities/phantom_assassin_stifling_dagger_lua/modifier_phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_stifling_dagger_lua_attack", "lua_abilities/phantom_assassin_stifling_dagger_lua/modifier_phantom_assassin_stifling_dagger_lua_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function phantom_assassin_stifling_dagger_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function phantom_assassin_stifling_dagger_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(targets) do
		-- Create Projectile
		local info = {
			Target = enemy,
			Source = caster,
			Ability = self,	
			EffectName = projectile_name,
			iMoveSpeed = projectile_speed,
			bReplaceExisting = false,                         -- Optional
			bProvidesVision = true,                           -- Optional
			iVisionRadius = projectile_vision,				-- Optional
			iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

	self:PlayEffects1()
end

function phantom_assassin_stifling_dagger_lua:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	local modifier = self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_phantom_assassin_stifling_dagger_lua_attack",
		{}
	)
	self:GetCaster():PerformAttack (
		hTarget,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	modifier:Destroy()

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_phantom_assassin_stifling_dagger_lua",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
end

--------------------------------------------------------------------------------
function phantom_assassin_stifling_dagger_lua:PlayEffects1()
	-- Get Resources
	local sound_cast = "Hero_PhantomAssassin.Dagger.Cast"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function phantom_assassin_stifling_dagger_lua:PlayEffects2( target )
	-- Get Resources
	local sound_target = "Hero_PhantomAssassin.Dagger.Target"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end