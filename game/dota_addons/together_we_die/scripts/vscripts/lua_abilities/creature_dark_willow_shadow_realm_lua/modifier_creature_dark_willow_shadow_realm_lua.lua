modifier_creature_dark_willow_shadow_realm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_dark_willow_shadow_realm_lua:IsHidden()
	return false
end

function modifier_creature_dark_willow_shadow_realm_lua:IsDebuff()
	return false
end

function modifier_creature_dark_willow_shadow_realm_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_dark_willow_shadow_realm_lua:OnCreated( kv )
	-- references
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
	self.buff_duration = 3

	if not IsServer() then return end
	-- set creation time
	self.create_time = GameRules:GetGameTime()

	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )

	self:PlayEffects()
end

function modifier_creature_dark_willow_shadow_realm_lua:OnRefresh( kv )
	-- references
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.buff_duration = 3

	if not IsServer() then return end
	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )
end

function modifier_creature_dark_willow_shadow_realm_lua:OnRemoved()
end

function modifier_creature_dark_willow_shadow_realm_lua:OnDestroy()
	-- stop sound
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_dark_willow_shadow_realm_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,

		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_creature_dark_willow_shadow_realm_lua:GetModifierAttackRangeBonus()
	return self.bonus_range
end
function modifier_creature_dark_willow_shadow_realm_lua:GetModifierProjectileName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack_dummy.vpcf"
end

function modifier_creature_dark_willow_shadow_realm_lua:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- calculate time
	local time = GameRules:GetGameTime() - self.create_time

	-- create modifier
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_creature_dark_willow_shadow_realm_lua_buff", -- modifier name
		{
			duration = self.buff_duration,
			record = params.record,
			damage = self.bonus_damage,
			time = time,
			target = params.target:entindex(),
		} -- kv
	)

	-- play sound
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_creature_dark_willow_shadow_realm_lua:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_dark_willow_shadow_realm_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_creature_dark_willow_shadow_realm_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

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