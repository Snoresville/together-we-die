modifier_omniknight_repel_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_repel_lua:IsHidden()
	-- cancel if break
	if self:GetCaster():PassivesDisabled() then return true end
	return false
end

function modifier_omniknight_repel_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_omniknight_repel_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.repel_chance = self:GetAbility():GetSpecialValueFor( "repel_chance" )
	self.heal_str_multiplier = self:GetAbility():GetSpecialValueFor( "heal_str_multiplier" )
end

function modifier_omniknight_repel_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.repel_chance = self:GetAbility():GetSpecialValueFor( "repel_chance" )
	self.heal_str_multiplier = self:GetAbility():GetSpecialValueFor( "heal_str_multiplier" )
end

function modifier_omniknight_repel_lua:OnRemoved()
end

function modifier_omniknight_repel_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_omniknight_repel_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

if IsServer() then
	function modifier_omniknight_repel_lua:OnAttackLanded( params )
		local caster = self:GetCaster()
		local target = params.target

		if caster:PassivesDisabled() then return end

		if self:GetParent() == target and self:GetParent():GetTeamNumber() ~= params.attacker:GetTeamNumber() and self:GetAbility():IsCooldownReady() then
			if not target:IsRealHero() then return end
			-- roll chance for repel
			if self:RollChance( self.repel_chance ) then
				-- heal
				print( "heal cal" )
				local heal = params.damage + (caster:GetStrength() * self:GetAbility():GetSpecialValueFor( "heal_str_multiplier" ))
				print( "heal" )
				target:Heal( heal, self:GetAbility() )
				print( "heal 2" )
				-- dispel target (good dispel)
				target:Purge( false, true, false, false, false )
				print( "purged" )
				-- cooldown
				self:GetAbility():UseResources( false, false, true )
				print( "cd" )
				self:PlayEffects( target )
				print( "effects" )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_omniknight_repel_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_omniknight_repel_lua:IsAura()
	return self:GetParent()==self:GetCaster()
end

function modifier_omniknight_repel_lua:GetModifierAura()
	return "modifier_omniknight_repel_lua"
end

function modifier_omniknight_repel_lua:GetAuraRadius()
	-- cancel if break
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.radius
end

function modifier_omniknight_repel_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_omniknight_repel_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_omniknight_repel_lua:PlayEffects( target )
	-- get resource
	local sound_cast = "Hero_Omniknight.Repel"
	local particle_cast = "particles/items2_fx/urn_of_shadows_heal_d.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end