centaur_warrunner_hoof_stomp_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function centaur_warrunner_hoof_stomp_lua:OnSpellStart()
	-- get references
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local str_multiplier = self:GetSpecialValueFor( "str_multiplier" )
	local damage = self:GetSpecialValueFor( "stomp_damage" ) + (caster:GetStrength() * str_multiplier)
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	-- Talent tree
	local special_hoof_stomp_str_multiplier_lua = caster:FindAbilityByName( "special_hoof_stomp_str_multiplier_lua" )
	if ( special_hoof_stomp_str_multiplier_lua and special_hoof_stomp_str_multiplier_lua:GetLevel() ~= 0 ) then
		str_multiplier = str_multiplier + special_hoof_stomp_str_multiplier_lua:GetSpecialValueFor( "value" )
	end
	-- Talent tree
	local special_hoof_stomp_radius_lua = caster:FindAbilityByName( "special_hoof_stomp_radius_lua" )
	if ( special_hoof_stomp_radius_lua and special_hoof_stomp_radius_lua:GetLevel() ~= 0 ) then
		radius = radius + special_hoof_stomp_radius_lua:GetSpecialValueFor( "value" )
	end
	-- Talent tree
	local special_hoof_stomp_stun_duration_lua = caster:FindAbilityByName( "special_hoof_stomp_stun_duration_lua" )
	if ( special_hoof_stomp_stun_duration_lua and special_hoof_stomp_stun_duration_lua:GetLevel() ~= 0 ) then
		stun_duration = stun_duration + special_hoof_stomp_stun_duration_lua:GetSpecialValueFor( "value" )
	end

	-- find affected units
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Apply stun debuff
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
	end

	-- Play effects
	self:PlayEffects()
end

function centaur_warrunner_hoof_stomp_lua:PlayEffects()
	-- get particles
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local sound_cast = "Hero_Centaur.HoofStomp"

	-- get data
	local radius = self:GetSpecialValueFor("radius")


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end