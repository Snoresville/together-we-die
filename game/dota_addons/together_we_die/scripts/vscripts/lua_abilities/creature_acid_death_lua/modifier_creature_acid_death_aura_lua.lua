--------------------------------------------------------------------------------
modifier_creature_acid_death_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_acid_death_aura_lua:IsHidden()
	return true
end

function modifier_creature_acid_death_aura_lua:IsDebuff()
	return false
end

function modifier_creature_acid_death_aura_lua:IsPurgable()
	return false
end

function modifier_creature_acid_death_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:GetModifierAura()
	return "modifier_creature_acid_death_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	-- effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_creature_acid_death_aura_lua:OnDestroy()
	if not IsServer() then return end

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations

function modifier_creature_acid_death_aura_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
	local sound_cast = "Hero_Alchemist.AcidSpray"

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

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end