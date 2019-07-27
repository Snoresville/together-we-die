roshan_sun_strike_lua = class({})
LinkLuaModifier( "modifier_roshan_sun_strike_lua_thinker", "lua_abilities/roshan_sun_strike_lua/modifier_roshan_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function roshan_sun_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- get values
	local delay = self:GetSpecialValueFor("delay")

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
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
			caster,
			self,
			"modifier_roshan_sun_strike_lua_thinker",
			{ duration = delay },
			point,
			caster:GetTeamNumber(),
			false
		)
	end
end