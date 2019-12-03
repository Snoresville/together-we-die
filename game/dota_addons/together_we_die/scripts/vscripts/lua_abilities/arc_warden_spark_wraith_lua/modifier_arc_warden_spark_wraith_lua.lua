modifier_arc_warden_spark_wraith_lua = class({})

--------------------------------------------------------------------------------

function modifier_arc_warden_spark_wraith_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_arc_warden_spark_wraith_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_arc_warden_spark_wraith_lua:OnCreated( kv )
	if not IsServer() then return end
	self.activated = false

	self.activation_delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )
	self.think_interval = self:GetAbility():GetSpecialValueFor( "think_interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.wraith_speed = self:GetAbility():GetSpecialValueFor( "wraith_speed" )
	self.wraith_vision_radius = self:GetAbility():GetSpecialValueFor( "wraith_vision_radius" )
	self.sound_loop = "Hero_ArcWarden.SparkWraith.Loop"
	self.caster = self:GetCaster()
	EmitSoundOn( self.sound_loop, self:GetParent() )

	self:StartIntervalThink( self.activation_delay )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_arc_warden_spark_wraith_lua:GetEffectName()
	return "particles/units/heroes/hero_arc_warden/arc_warden_wraith.vpcf"
end

function modifier_arc_warden_spark_wraith_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_arc_warden_spark_wraith_lua:OnIntervalThink()
	-- Check if ready
	if self.activated then
		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		if #enemies ~= 0 then
			for _,enemy in pairs(enemies) do
				self:SendProjectile( enemy )
			end
	
			-- Play Sound Effects
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_ArcWarden.SparkWraith.Activate", self.caster )
			-- Remove thinker
			-- stop sound
			StopSoundOn( self.sound_loop, self:GetParent() )
			UTIL_Remove( self:GetParent() )
		end
	else
		self.activated = true
		self:StartIntervalThink( self.think_interval )
	end
end
--------------------------------------------------------------------------------
function modifier_arc_warden_spark_wraith_lua:SendProjectile( target )
	local projectile_name = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj_model.vpcf"

	-- create projectile
	local info = {
		Target = target,
		Source = self.caster,
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = self.wraith_speed,
		vSourceLoc= self:GetParent():GetAbsOrigin(),
		bDodgeable = true,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = self.wraith_vision_radius,                              -- Optional
		iVisionTeamNumber = self.caster:GetTeamNumber(),        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)	
end

--------------------------------------------------------------------------------
