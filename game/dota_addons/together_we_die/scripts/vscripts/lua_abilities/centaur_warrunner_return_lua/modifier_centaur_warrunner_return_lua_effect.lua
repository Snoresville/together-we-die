modifier_centaur_warrunner_return_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_centaur_warrunner_return_lua_effect:IsHidden()
	return false
end

function modifier_centaur_warrunner_return_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_centaur_warrunner_return_lua_effect:OnCreated( kv )
	-- references
	self.base_damage = self:GetAbility():GetSpecialValueFor( "return_damage" ) -- special value
	self.strength_pct = self:GetAbility():GetSpecialValueFor( "strength_pct" ) -- special value
end

function modifier_centaur_warrunner_return_lua_effect:OnRefresh( kv )
	-- references
	self.base_damage = self:GetAbility():GetSpecialValueFor( "return_damage" ) -- special value
	self.strength_pct = self:GetAbility():GetSpecialValueFor( "strength_pct" ) -- special value
end

function modifier_centaur_warrunner_return_lua_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_centaur_warrunner_return_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end
function modifier_centaur_warrunner_return_lua_effect:OnAttacked( params )
	local abilityParent = self:GetParent()
	local caster = self:GetCaster()
	if IsServer() and abilityParent == params.target and abilityParent:GetTeamNumber()~=params.attacker:GetTeamNumber() then
		if abilityParent:IsIllusion() then
			return
		end
		if params.attacker == abilityParent or self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) then
			return
		end

		-- get damage
		local str_multiplier = self.strength_pct

		-- Talent tree
		local special_return_str_multiplier_lua = caster:FindAbilityByName( "special_return_str_multiplier_lua" )
		if ( special_return_str_multiplier_lua and special_return_str_multiplier_lua:GetLevel() ~= 0 ) then
			str_multiplier = str_multiplier + special_return_str_multiplier_lua:GetSpecialValueFor( "value" )
		end

		local damage = self.base_damage + caster:GetStrength()*(str_multiplier/100)

		-- Apply Damage
		local damageTable = {
			victim = params.attacker,
			attacker = abilityParent,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)

		-- Play effects
		if params.attacker:IsConsideredHero() then
			self:PlayEffects( params.attacker )
		end
	end
end

-- Helper: Flag operations
function modifier_centaur_warrunner_return_lua_effect:FlagExist(a,b)--Bitwise Exist
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_centaur_warrunner_return_lua_effect:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_centaur_warrunner_return_lua_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end
function modifier_centaur_warrunner_return_lua_effect:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_return.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
end