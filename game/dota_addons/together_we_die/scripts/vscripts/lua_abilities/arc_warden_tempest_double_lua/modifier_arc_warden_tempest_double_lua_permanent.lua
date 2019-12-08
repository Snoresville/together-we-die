--------------------------------------------------------------------------------
modifier_arc_warden_tempest_double_lua_permanent = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_warden_tempest_double_lua_permanent:IsHidden()
	return false
end

function modifier_arc_warden_tempest_double_lua_permanent:IsDebuff()
	return false
end

function modifier_arc_warden_tempest_double_lua_permanent:IsStunDebuff()
	return false
end

function modifier_arc_warden_tempest_double_lua_permanent:IsPurgable()
	return false
end

function modifier_arc_warden_tempest_double_lua_permanent:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_arc_warden_tempest_double_lua_permanent:GetModifierSuperIllusion()
	return 1
end

function modifier_arc_warden_tempest_double_lua_permanent:GetModifierIllusionLabel()
	return 1
end

function modifier_arc_warden_tempest_double_lua_permanent:IsPermanent()
	return true
end

function modifier_arc_warden_tempest_double_lua_permanent:OnDeath( event )
	if event.unit == self:GetParent() then
		self:GetParent():MakeIllusion()
	end
end

function modifier_arc_warden_tempest_double_lua_permanent:OnRespawn( event )
	if event.unit == self:GetParent() then
		self:GetParent():MakeIllusion()
	end
end

function modifier_arc_warden_tempest_double_lua_permanent:OnTakeDamage( event )
	if not event.unit:IsAlive() and event.unit == self:GetParent() then
		self:GetParent():MakeIllusion()
	end
end


--------------------------------------------------------------------------------
-- Initializations
function modifier_arc_warden_tempest_double_lua_permanent:OnCreated( kv )
end

function modifier_arc_warden_tempest_double_lua_permanent:OnRefresh( kv )
end

function modifier_arc_warden_tempest_double_lua_permanent:OnDestroy()
	if not IsServer() then return end
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_arc_warden_tempest_double_lua_permanent:DeclareFunctions()
	local funcs =  {
		MODIFIER_PROPERTY_SUPER_ILLUSION,
		MODIFIER_PROPERTY_ILLUSION_LABEL,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Animation Effects
function modifier_arc_warden_tempest_double_lua_permanent:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_arc_warden_tempest_double_lua_permanent:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/generic_gameplay/illusion_killed.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end