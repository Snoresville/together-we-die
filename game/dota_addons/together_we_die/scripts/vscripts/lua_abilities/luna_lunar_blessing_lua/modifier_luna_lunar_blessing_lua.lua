modifier_luna_lunar_blessing_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_luna_lunar_blessing_lua:IsHidden()
	-- cancel if break
	if self:GetCaster():PassivesDisabled() then return true end
	return false
end

function modifier_luna_lunar_blessing_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_luna_lunar_blessing_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.lucent_beam_chance = self:GetAbility():GetSpecialValueFor( "lucent_beam_chance" )
end

function modifier_luna_lunar_blessing_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.lucent_beam_chance = self:GetAbility():GetSpecialValueFor( "lucent_beam_chance" )
end

function modifier_luna_lunar_blessing_lua:OnRemoved()
end

function modifier_luna_lunar_blessing_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_luna_lunar_blessing_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

if IsServer() then
	function modifier_luna_lunar_blessing_lua:OnAttackLanded( params )
		local caster = self:GetCaster()

		if caster:PassivesDisabled() then return end

		if self:GetParent() == params.target and self:GetParent():GetTeamNumber() ~= params.attacker:GetTeamNumber() and self:GetAbility():IsCooldownReady() then
			-- roll chance for lucent beam
			if self:RollChance( self.lucent_beam_chance ) then
				local lucent_beam_ability = caster:FindAbilityByName( "luna_lucent_beam_lua" )
				if ( lucent_beam_ability and lucent_beam_ability:GetLevel() ~= 0 ) then
					-- cast to attacker
					caster:SetCursorCastTarget( params.attacker )
					lucent_beam_ability:OnSpellStart()
					-- cooldown
					self:GetAbility():UseResources( false, false, true )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_luna_lunar_blessing_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_luna_lunar_blessing_lua:IsAura()
	return self:GetParent()==self:GetCaster()
end

function modifier_luna_lunar_blessing_lua:GetModifierAura()
	return "modifier_luna_lunar_blessing_lua"
end

function modifier_luna_lunar_blessing_lua:GetAuraRadius()
	-- cancel if break
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.radius
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end