modifier_invoker_tornado_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_tornado_lua_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_tornado_lua_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.distance = self:GetAbility():GetOrbSpecialValueFor( "travel_distance", "w" )
		self.speed = self:GetAbility():GetSpecialValueFor( "travel_speed" )
		self.vision = self:GetAbility():GetSpecialValueFor( "vision_distance" )
		self.vision_duration = self:GetAbility():GetSpecialValueFor( "end_vision_duration" )
		self.lift_duration = self:GetAbility():GetOrbSpecialValueFor( "lift_duration", "q" )
		local base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
		local wex_damage = self:GetAbility():GetOrbSpecialValueFor( "wex_damage", "w" ) + self:GetCaster():GetIntellect() * self:GetAbility():GetOrbSpecialValueFor( "int_multiplier", "w" )
		self.landing_damage = base_damage + wex_damage

		self.interval = 0.2

		-- vision
		self:GetParent():SetDayTimeVisionRange( self.vision )
		self:GetParent():SetNightTimeVisionRange( self.vision )

		-- calculate spinning
		local ideal_degrees_per_second = 666.666
		local ideal_full_spins = (ideal_degrees_per_second / 360) * self.lift_duration
		ideal_full_spins = math.floor(ideal_full_spins + .5)  --Round the number of spins to aim for to the closest integer.
		local degrees_per_second_ending_in_same_forward_vector = (360 * ideal_full_spins) / self.lift_duration
		self.tornado_degrees_to_spin = degrees_per_second_ending_in_same_forward_vector * .03

		-- Start interval
		self:StartIntervalThink( self.interval )

		-- play effects
		self:PlayEffects()
	end
end

function modifier_invoker_tornado_lua_thinker:OnRefresh( kv )
	
end

function modifier_invoker_tornado_lua_thinker:OnDestroy( kv )
	if IsServer() then
		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.vision, self.vision_duration, false)

		-- stop effects
		local sound_loop = "Hero_Invoker.Tornado"
		StopSoundOn( sound_loop, self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_invoker_tornado_lua_thinker:OnIntervalThink()
	self:Move_Burn()
end

function modifier_invoker_tornado_lua_thinker:Burn()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- add modifier
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_invoker_tornado_lua", -- modifier name
			{
				duration = self.lift_duration,
				tornado_degrees_to_spin = self.tornado_degrees_to_spin,
				cyclone_initial_height = 350,
				cyclone_min_height = 300,
				cyclone_max_height = 400,
				landing_damage = self.landing_damage,
			} -- kv
		)
		-- Play effects
		local sound_cast = "Hero_Invoker.Tornado.Target"
		EmitSoundOn( sound_cast, enemy )
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_invoker_tornado_lua_thinker:Move_Burn()
	local parent = self:GetParent()

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:Destroy()
		return
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_invoker_tornado_lua_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
	local sound_loop = "Hero_Invoker.Tornado"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOn( sound_loop, self:GetParent() )
end