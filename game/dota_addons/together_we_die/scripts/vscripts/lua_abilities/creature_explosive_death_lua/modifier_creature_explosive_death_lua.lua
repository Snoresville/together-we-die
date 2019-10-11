modifier_creature_explosive_death_lua = class({})

--------------------------------------------------------------------------------
function modifier_creature_explosive_death_lua:IsHidden()
	return true
end

function modifier_creature_explosive_death_lua:IsDebuff()
	return false
end

function modifier_creature_explosive_death_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_explosive_death_lua:OnCreated( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
end

--------------------------------------------------------------------------------

function modifier_creature_explosive_death_lua:OnRefresh( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
end

--------------------------------------------------------------------------------

function modifier_creature_explosive_death_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_creature_explosive_death_lua:OnDeath( event )
	if event.unit == nil or event.attacker == nil then
		return
	end

	if event.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and event.unit == self:GetParent() then
		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
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
			-- damage
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end
		self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
function modifier_creature_explosive_death_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_techies/techies_suicide.vpcf"
	local sound_cast = "Hero_Techies.Suicide"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end