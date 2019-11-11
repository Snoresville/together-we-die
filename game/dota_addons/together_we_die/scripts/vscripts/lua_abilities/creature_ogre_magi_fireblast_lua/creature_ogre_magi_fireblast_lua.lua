--------------------------------------------------------------------------------
creature_ogre_magi_fireblast_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_ogre_magi_fireblast_lua", "lua_abilities/creature_ogre_magi_fireblast_lua/modifier_creature_ogre_magi_fireblast_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function creature_ogre_magi_fireblast_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
--------------------------------------------------------------------------------
-- Ability Start
function creature_ogre_magi_fireblast_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target ~= nil and target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local duration = self:GetSpecialValueFor( "stun_duration" )
	local mana_loss_duration = self:GetSpecialValueFor( "mana_loss_duration" )
	local damage = self:GetSpecialValueFor( "fireblast_damage" )
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

	-- Apply damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	for _,enemy in pairs(enemies) do
		if not enemy:TriggerSpellAbsorb( self ) then
			damageTable.victim = enemy
			local additional_damage = 0
			if enemy:IsRealHero() then
				additional_damage = enemy:GetStrength() * self:GetSpecialValueFor( "str_multiplier" )
			end
			damageTable.damage = damage + additional_damage
			ApplyDamage( damageTable )

			-- stun
			enemy:AddNewModifier(
				self:GetCaster(),
				self, 
				"modifier_generic_stunned_lua", 
				{duration = duration}
			)

			enemy:AddNewModifier(
				self:GetCaster(),
				self, 
				"modifier_creature_ogre_magi_fireblast_lua", 
				{duration = mana_loss_duration}
			)

			-- play effects
			self:PlayEffects( enemy )
		end
	end

end

--------------------------------------------------------------------------------
function creature_ogre_magi_fireblast_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf"
	local sound_cast = "Hero_OgreMagi.Fireblast.Cast"
	local sound_target = "Hero_OgreMagi.Fireblast.Target"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end