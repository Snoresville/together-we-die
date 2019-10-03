modifier_invoker_tornado_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_invoker_tornado_lua:IsHidden()
	return false
end

function modifier_invoker_tornado_lua:IsDebuff()
	return true
end

function modifier_invoker_tornado_lua:IsStunDebuff()
	return true
end

function modifier_invoker_tornado_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_invoker_tornado_lua:OnCreated( kv )
	self.landing_damage = kv.landing_damage
	if not IsServer() then return end
	self.tornado_degrees_to_spin = kv.tornado_degrees_to_spin
	self.tornado_forward_vector = self:GetParent():GetForwardVector()

	-- Position variables
	local target_origin = self:GetParent():GetAbsOrigin()
	local target_initial_x = target_origin.x
	local target_initial_y = target_origin.y
	local target_initial_z = target_origin.z
	self.position = Vector(target_initial_x, target_initial_y, target_initial_z)  --This is updated whenever the target has their position changed.
	self.lift_duration = kv.duration
	self.ground_position = GetGroundPosition(self.position, self:GetParent())
	self.cyclone_initial_height = kv.cyclone_initial_height + self.ground_position.z
	self.cyclone_min_height = kv.cyclone_min_height + self.ground_position.z
	self.cyclone_max_height = kv.cyclone_max_height + self.ground_position.z

	-- Height per time calculation
	self.time_to_reach_initial_height = self.lift_duration / 10  --1/10th of the total cyclone duration will be spent ascending and descending to and from the initial height.
	self.initial_ascent_height_per_frame = ((self.cyclone_initial_height - self.position.z) / self.time_to_reach_initial_height) * .03  --This is the height to add every frame when the unit is first cycloned, and applies until the caster reaches their max height.
	
	self.up_down_cycle_height_per_frame = self.initial_ascent_height_per_frame / 3  --This is the height to add or remove every frame while the caster is in up/down cycle mode.
	if self.up_down_cycle_height_per_frame > 7.5 then  --Cap this value so the unit doesn't jerk up and down for short-duration cyclones.
		self.up_down_cycle_height_per_frame = 7.5
	end
	
	self.final_descent_height_per_frame = nil  --This is calculated when the unit begins descending.

	-- Time to go down
	self.time_to_stop_fly = self.lift_duration - self.time_to_reach_initial_height
	self.time_in_air = 0

	-- Loop up and down
	self.going_up = true

	self.interval = 0.03
	-- Start interval
	self:OnIntervalThink()
	self:StartIntervalThink( self.interval )
end

function modifier_invoker_tornado_lua:OnRefresh( kv )
end

function modifier_invoker_tornado_lua:OnDestroy( kv )
	self:PlayEffects2()
	if not IsServer() then return end
	self:GetParent():SetForwardVector(self.tornado_forward_vector)
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.landing_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_invoker_tornado_lua:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end
--------------------------------------------------------------------------------
function modifier_invoker_tornado_lua:OnIntervalThink()
	-- Effects
	self:PlayEffects1()

	self.time_in_air = self.time_in_air + self.interval
		
	-- First send the target to the cyclone's initial height.
	if self.position.z < self.cyclone_initial_height and self.time_in_air <= self.time_to_reach_initial_height then
		--print("+",initial_ascent_height_per_frame,position.z)
		self.position.z = self.position.z + self.initial_ascent_height_per_frame
		self:GetParent():SetAbsOrigin(self.position)
		-- Go down until the target reaches the ground.
	elseif self.time_in_air > self.time_to_stop_fly and self.time_in_air <= self.lift_duration then
		--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
		--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration is supposed to end.
		if self.final_descent_height_per_frame == nil then
			local descent_initial_height_above_ground = self.position.z - self.ground_position.z
			--print("ground position: " .. GetGroundPosition(position, target).z)
			--print("position.z : " .. position.z)
			self.final_descent_height_per_frame = (descent_initial_height_above_ground / self.time_to_reach_initial_height) * .03
		end
			
		--print("-",final_descent_height_per_frame,position.z)
		self.position.z = self.position.z - self.final_descent_height_per_frame
		self:GetParent():SetAbsOrigin(self.position)
	-- Do Up and down cycles
	elseif self.time_in_air <= self.lift_duration then
		-- Up
		if self.position.z < self.cyclone_max_height and self.going_up then 
			--print("going up")
			self.position.z = self.position.z + self.up_down_cycle_height_per_frame
			self:GetParent():SetAbsOrigin(self.position)
		-- Down
		elseif self.position.z >= self.cyclone_min_height then
			self.going_up = false
			--print("going down")
			self.position.z = self.position.z - self.up_down_cycle_height_per_frame
			self:GetParent():SetAbsOrigin(self.position)
		-- Go up again
		else
			--print("going up again")
			self.going_up = true
		end

	-- End
	else
		--print(GetGroundPosition(target:GetAbsOrigin(), target))
		--print("End TornadoHeight")
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
--------------------------------------------------------------------------------
function modifier_invoker_tornado_lua:PlayEffects1()
	self:GetParent():SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, self.tornado_degrees_to_spin, 0), self:GetParent():GetForwardVector()))
end

function modifier_invoker_tornado_lua:PlayEffects2()
	-- Play effects
	local sound_cast = "Hero_Invoker.Tornado.LandDamage"
	EmitSoundOn( sound_cast, self:GetParent() )
end