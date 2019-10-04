modifier_skywrath_mage_concussive_shot_auto_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_skywrath_mage_concussive_shot_auto_lua:IsHidden()
	return true
end

function modifier_skywrath_mage_concussive_shot_auto_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_skywrath_mage_concussive_shot_auto_lua:OnCreated( kv )
	-- references
	self.search_radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_skywrath_mage_concussive_shot_auto_lua:OnRefresh( kv )
	-- references
	self.search_radius = self:GetAbility():GetSpecialValueFor( "launch_radius" )
end

function modifier_skywrath_mage_concussive_shot_auto_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_skywrath_mage_concussive_shot_auto_lua:OnIntervalThink()
	if not IsServer() then return end

	local modifierParent = self:GetParent()
	local selfAbility = self:GetAbility()
	if modifierParent:IsAlive()and not modifierParent:IsIllusion() and not modifierParent:PassivesDisabled() and selfAbility:IsCooldownReady() then
		-- search enemy heroes
		local enemies = FindUnitsInRadius(
			modifierParent:GetTeamNumber(),	-- int, your team number
			modifierParent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		target = enemies[1]

		-- if no one found, it's dud
		if not target then
			--self:PlayEffects2()
			return
		end

		self:SendProjectile( modifierParent, target )

		-- cooldown
		selfAbility:UseResources( false, false, true )

		if modifierParent:HasScepter() then
			target_2 = enemies[1]		-- could be nil
			if target_2==target then
				target_2 = enemies[2]	-- could be nil
			end
			if target_2 and (not target_2:IsMagicImmune()) then
				self:SendProjectile( modifierParent, target )
			end
		end
	end
end

function modifier_skywrath_mage_concussive_shot_auto_lua:SendProjectile( caster, target )
	local projectile_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"
	local projectile_speed = self:GetAbility():GetSpecialValueFor( "speed" )
	local projectile_vision = self:GetAbility():GetSpecialValueFor( "shot_vision" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)	

	-- play effects
	self:GetAbility():PlayEffects1( target )
end