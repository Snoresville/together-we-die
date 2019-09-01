-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Break behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_huskar_life_break_lua = class({})
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_life_break_lua:IsHidden()
	return false
end

function modifier_huskar_life_break_lua:IsDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsStunDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_huskar_life_break_lua:OnCreated( kv )
	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor( "health_damage" )
	if self:GetParent():HasScepter() then
		self.damage_pct = self:GetAbility():GetSpecialValueFor( "health_damage_scepter" )
	end
	self.cost_pct = self:GetAbility():GetSpecialValueFor( "health_cost_percent" )
	self.str_damage = self:GetAbility():GetSpecialValueFor( "str_multiplier" ) * self:GetCaster():GetStrength()

	self.close_distance = 80
	self.far_distance = 1450

	if IsServer() then
		self.target = tempTable:RetATValue( kv.target )

		-- basic purge
		self:GetParent():Purge( false, true, false, false, false )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_huskar_life_break_lua:OnRefresh( kv )
	
end

function modifier_huskar_life_break_lua:OnRemoved()
end

function modifier_huskar_life_break_lua:OnDestroy()
	if IsServer() then
		-- IMPORTANT: this is a must, or else the game will crash!
		self:GetParent():InterruptMotionControllers( true )

		-- destroy buff
		local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_huskar_life_break_lua_buff", self:GetParent() )
		if modifier then
			modifier:Destroy()
		end

		if not self.success then return end

		local search = self:GetAbility():GetSpecialValueFor( "radius" )
		local caster = self:GetCaster()
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		local damageTable = {
			attacker = caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}

		for _, enemy in pairs(targets) do
			-- percentage enemy damage
			damageTable.victim = enemy
			damageTable.damage = self.damage_pct * enemy:GetHealth() + self.str_damage
			ApplyDamage(damageTable)
			-- apply debuff
			enemy:AddNewModifier(
				caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_huskar_life_break_lua_debuff", -- modifier name
				{ duration = self:GetAbility():GetDuration() } -- kv
			)
		end

		-- percentage self damage
		damageTable.victim = caster
		damageTable.damage = self.cost_pct * caster:GetHealth()
		damageTable.damage_type = DAMAGE_TYPE_PURE
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		ApplyDamage(damageTable)

		-- play effects
		self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_huskar_life_break_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_huskar_life_break_lua:UpdateHorizontalMotion( me, dt )
	local origin = self:GetParent():GetOrigin()

	if not self.target:IsAlive() then
		self:EndCharge( false )
	end

	-- get direction
	local direction = self.target:GetOrigin() - origin
	direction.z = 0
	local distance = direction:Length2D()
	direction = direction:Normalized()

	-- stop if close to target
	if distance<self.close_distance then
		self:EndCharge( true )
	elseif distance>self.far_distance then
		self:EndCharge( false )
	end

	-- move towards direction
	local target = origin + direction * self.speed * dt
	self:GetParent():SetOrigin( target )

	-- face towards target
	self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_huskar_life_break_lua:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_huskar_life_break_lua:EndCharge( success )
	-- cancel debuff if linken
	if success and (not self.target:TriggerSpellAbsorb(self:GetAbility())) then
		self.success = true
	end
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_huskar_life_break_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_life_break.vpcf"
	local sound_target = "Hero_Huskar.Life_Break.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self.target )
end