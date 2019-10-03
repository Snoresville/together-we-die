--------------------------------------------------------------------------------
modifier_creature_acid_death_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_acid_death_lua:IsHidden()
	return true
end

function modifier_creature_acid_death_lua:IsDebuff()
	return false
end

function modifier_creature_acid_death_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			damage = self:GetAbility():GetSpecialValueFor( "explosion_damage" ),
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
	end
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:GetEffectName()
	return "particles/econ/generic/generic_buff_1/generic_buff_1.vpcf"
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:OnDeath(event)
	if event.unit == self:GetParent() then
		local parent = self:GetParent()
		local parentOrigin = self:GetParent():GetOrigin()

		-- find enemies
		local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			parentOrigin,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.aura_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- play effects
		self:PlayEffects()

		for _,enemy in pairs(enemies) do
			-- damage
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			local enemyOrigin = enemy:GetOrigin()

			-- knockback
			enemy:AddNewModifier(
				parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_generic_knockback_lua", -- modifier name
				{
					duration = self.knockback_duration,
					distance = self.knockback_distance,
					height = 30,
					direction_x = enemyOrigin.x - parentOrigin.x,
					direction_y = enemyOrigin.y - parentOrigin.y,
				} -- kv
			)
		end

		local point = parentOrigin
		CreateModifierThinker(
			parent,
			self:GetAbility(),
			"modifier_creature_acid_death_aura_lua",
			{ duration = self.duration },
			point,
			parent:GetTeamNumber(),
			false
		)
	end
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.aura_radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end