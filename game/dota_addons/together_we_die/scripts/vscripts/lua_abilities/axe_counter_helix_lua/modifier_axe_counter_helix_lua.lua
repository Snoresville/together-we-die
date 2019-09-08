modifier_axe_counter_helix_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_axe_counter_helix_lua:IsHidden()
	return true
end

function modifier_axe_counter_helix_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_axe_counter_helix_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
		-- ApplyDamage(damageTable)
	end
end

function modifier_axe_counter_helix_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )
end

function modifier_axe_counter_helix_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_axe_counter_helix_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_axe_counter_helix_lua:OnAttackLanded( params )
	local abilityCaster = self:GetCaster()
	local selfAbility = self:GetAbility()
	if IsServer() and (not abilityCaster:PassivesDisabled()) and abilityCaster == params.target and abilityCaster:GetTeamNumber()~=params.attacker:GetTeamNumber() and selfAbility:IsCooldownReady() then
		if params.attacker:IsOther() then return end
		print ('call')

		-- roll dice
		if self:RollChance( self.chance ) then
			print ('proc')
			local damage = selfAbility:GetSpecialValueFor("damage") + (abilityCaster:GetStrength() * selfAbility:GetSpecialValueFor("str_multiplier"))
			self.damageTable.damage = damage

			-- find enemies
			local enemies = FindUnitsInRadius(
				abilityCaster:GetTeamNumber(),	-- int, your team number
				abilityCaster:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

			-- damage
			for _,enemy in pairs(enemies) do
				self.damageTable.victim = enemy
				ApplyDamage( self.damageTable )
			end

			-- cooldown
			selfAbility:UseResources( false, false, true )

			-- effects
			self:PlayEffects()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_counter_helix_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	local sound_cast = "Hero_Axe.CounterHelix"
	self:GetParent():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
	self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_3 )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_axe_counter_helix_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end