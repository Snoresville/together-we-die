--------------------------------------------------------------------------------
legion_commander_overwhelming_odds_lua = class({})

--------------------------------------------------------------------------------
-- AOE Radius
function legion_commander_overwhelming_odds_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function legion_commander_overwhelming_odds_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local vision_duration = 6

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Precache damage
	local damage_per_unit = self:GetSpecialValueFor("damage_per_unit") + self:GetSpecialValueFor("str_multiplier_per_unit") * #enemies
	local damage = self:GetSpecialValueFor("damage") + (caster:GetStrength() * self:GetSpecialValueFor("str_multiplier")) + damage_per_unit
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	for _,enemy in pairs(enemies) do
		-- Apply damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, radius, vision_duration, true )

	self:PlayEffects( point, radius, vision_duration )
end

--------------------------------------------------------------------------------
function legion_commander_overwhelming_odds_lua:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf"
	local sound_caster = "Hero_LegionCommander.Overwhelming.Cast"
	local sound_cast = "Hero_LegionCommander.Overwhelming.Location"
	local forwardVec = point - self:GetCaster():GetOrigin()
            forwardVec = forwardVec:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( radius, 1, 1 ) )
	--ParticleManager:SetParticleControlForward( effect_cast, point, forwardVec )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_caster, self:GetCaster() )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end