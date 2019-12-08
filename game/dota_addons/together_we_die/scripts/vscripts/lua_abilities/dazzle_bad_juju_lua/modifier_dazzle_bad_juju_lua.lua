modifier_dazzle_bad_juju_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_bad_juju_lua:IsHidden()
	return true
end

function modifier_dazzle_bad_juju_lua:IsDebuff()
	return false
end

function modifier_dazzle_bad_juju_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dazzle_bad_juju_lua:OnCreated( kv )
	-- references
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_dazzle_bad_juju_lua:OnRefresh( kv )
	-- references
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_dazzle_bad_juju_lua:OnRemoved()
end

function modifier_dazzle_bad_juju_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_bad_juju_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}

	return funcs
end

function modifier_dazzle_bad_juju_lua:GetModifierPercentageCooldown()
	if not self:GetCaster():PassivesDisabled() then
		return self.cooldown_reduction
	end

	return 0
end

function modifier_dazzle_bad_juju_lua:OnAbilityFullyCast( params )
	local caster = self:GetCaster()
	if params.unit~=caster then return end
	if params.ability==self:GetAbility() then return end

	-- cancel if break
	if caster:PassivesDisabled() then return end

	-- Find targets near caster and give debuff stack
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
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
		-- reduce armor
		enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_dazzle_bad_juju_lua_debuff", -- modifier name
			{ duration = self.duration } -- kv
		)
	end
end