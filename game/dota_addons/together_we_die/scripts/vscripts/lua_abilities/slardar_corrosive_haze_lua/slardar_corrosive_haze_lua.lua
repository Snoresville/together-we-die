slardar_corrosive_haze_lua = class({})
LinkLuaModifier( "modifier_slardar_corrosive_haze_lua", "lua_abilities/slardar_corrosive_haze_lua/modifier_slardar_corrosive_haze_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function slardar_corrosive_haze_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function slardar_corrosive_haze_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- cancel if blocked
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local debuff_duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor( "radius" )

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if not enemy:TriggerSpellAbsorb( self ) then
			-- Add modifier
			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_slardar_corrosive_haze_lua", -- modifier name
				{ duration = debuff_duration } -- kv
			)

			-- Play sounds
			EmitSoundOn( "Hero_Slardar.Amplify_Damage", enemy )
		end
	end
end
