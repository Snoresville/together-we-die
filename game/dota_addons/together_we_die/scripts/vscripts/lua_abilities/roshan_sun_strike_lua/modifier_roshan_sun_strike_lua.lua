modifier_roshan_sun_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_sun_strike_lua:IsHidden()
	return true
end

function modifier_roshan_sun_strike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_sun_strike_lua:OnCreated( kv )
	-- references
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	local interval = 1.0

	if IsServer() then
		self:StartIntervalThink( interval )
	end
end

function modifier_roshan_sun_strike_lua:OnRefresh( kv )
	-- references
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
end

function modifier_roshan_sun_strike_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_sun_strike_lua:OnIntervalThink()
	if not IsServer() then return end

	

	local modifierParent = self:GetParent()
	local selfAbility = self:GetAbility()
	if modifierParent:IsAlive() and not modifierParent:PassivesDisabled() and selfAbility:IsCooldownReady() then
		local enemies = FindUnitsInRadius(
			modifierParent:GetTeamNumber(),	-- int, your team number
			modifierParent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			local point = enemy:GetOrigin()
			CreateModifierThinker(
				modifierParent,
				selfAbility,
				"modifier_roshan_sun_strike_lua_thinker",
				{ duration = self.delay },
				point,
				modifierParent:GetTeamNumber(),
				false
			)
		end

		selfAbility:UseResources( false, false, true )
	end
end