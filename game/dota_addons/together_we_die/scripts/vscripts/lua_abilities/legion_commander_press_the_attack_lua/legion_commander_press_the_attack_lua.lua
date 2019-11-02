--------------------------------------------------------------------------------
legion_commander_press_the_attack_lua = class({})
LinkLuaModifier( "modifier_legion_commander_press_the_attack_lua", "lua_abilities/legion_commander_press_the_attack_lua/modifier_legion_commander_press_the_attack_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function legion_commander_press_the_attack_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function legion_commander_press_the_attack_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- Find Units in Radius
	local friends = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- add modifier
	for _,friend in pairs(friends) do
		friend:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_legion_commander_press_the_attack_lua", -- modifier name
			{ duration = duration } -- kv
		)
		-- dispel target (good dispel)
		friend:Purge( false, true, false, false, false )

		-- play effects
		self:PlayEffects( friend )
	end
end

-- --------------------------------------------------------------------------------
function legion_commander_press_the_attack_lua:PlayEffects( target )
	-- Create Sound
	local sound_cast = "Hero_LegionCommander.PressTheAttack"
	EmitSoundOn( sound_cast, target )
end