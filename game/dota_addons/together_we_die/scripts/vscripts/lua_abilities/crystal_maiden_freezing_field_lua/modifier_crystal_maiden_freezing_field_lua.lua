modifier_crystal_maiden_freezing_field_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystal_maiden_freezing_field_lua:IsHidden()
	return true
end

function modifier_crystal_maiden_freezing_field_lua:IsDebuff()
	return false
end

function modifier_crystal_maiden_freezing_field_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_crystal_maiden_freezing_field_lua:IsAura()
	return true
end

function modifier_crystal_maiden_freezing_field_lua:GetModifierAura()
	return "modifier_crystal_maiden_freezing_field_lua_effect"
end

function modifier_crystal_maiden_freezing_field_lua:GetAuraRadius()
	return self.slow_radius
end

function modifier_crystal_maiden_freezing_field_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_crystal_maiden_freezing_field_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_crystal_maiden_freezing_field_lua:GetAuraDuration()
	return self.slow_duration
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_freezing_field_lua:OnCreated( kv )
	-- references
	local eAbility = self:GetAbility()
	self.slow_radius = eAbility:GetSpecialValueFor( "radius" )
	self.slow_duration = eAbility:GetSpecialValueFor( "slow_duration" )
	self.explosion_radius = eAbility:GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = eAbility:GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = eAbility:GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = eAbility:GetSpecialValueFor( "explosion_max_dist" )
	local eCaster = self:GetCaster()
	local explosion_damage = eAbility:GetSpecialValueFor( "damage" ) + (eCaster:GetIntellect() * eAbility:GetSpecialValueFor("int_multiplier"))

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = eCaster,
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
		self:PlayEffects1()
	end
end

function modifier_crystal_maiden_freezing_field_lua:OnRefresh( kv )
	-- references
	local eAbility = self:GetAbility()
	self.slow_radius = eAbility:GetSpecialValueFor( "radius" )
	self.slow_duration = eAbility:GetSpecialValueFor( "slow_duration" )
	self.explosion_radius = eAbility:GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = eAbility:GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = eAbility:GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = eAbility:GetSpecialValueFor( "explosion_max_dist" )
	local eCaster = self:GetCaster()
	local explosion_damage = eAbility:GetSpecialValueFor( "damage" ) + (eCaster:GetIntellect() * eAbility:GetSpecialValueFor("int_multiplier"))

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = eCaster,
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()
	end
end

function modifier_crystal_maiden_freezing_field_lua:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_crystal_maiden_freezing_field_lua:OnIntervalThink()
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self:GetCaster():GetOrigin() + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- Play effects
	self:PlayEffects2( point )
end

--------------------------------------------------------------------------------
-- Effects
function modifier_crystal_maiden_freezing_field_lua:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
	self.sound_cast = "hero_Crystal.freezingField.wind"

	-- Create Particle
	-- self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self.effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Play sound
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_crystal_maiden_freezing_field_lua:PlayEffects2( point )
	-- Play particles
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"

	-- Create particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )

	-- Play sound
	local sound_cast = "hero_Crystal.freezingField.explosion"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function modifier_crystal_maiden_freezing_field_lua:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end