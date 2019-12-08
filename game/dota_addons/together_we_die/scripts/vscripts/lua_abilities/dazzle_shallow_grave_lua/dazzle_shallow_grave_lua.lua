dazzle_shallow_grave_lua = class({})
LinkLuaModifier( "modifier_dazzle_shallow_grave_lua", "lua_abilities/dazzle_shallow_grave_lua/modifier_dazzle_shallow_grave_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function dazzle_shallow_grave_lua:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
--------------------------------------------------------------------------------
-- AOE Radius
function dazzle_shallow_grave_lua:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "scepter_radius" )
	end

	return 0
end

--------------------------------------------------------------------------------
-- Ability Start
function dazzle_shallow_grave_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("duration_tooltip")

	if self:GetCaster():HasScepter() then
		-- AOE when there is scepter
		local search = self:GetSpecialValueFor( "scepter_radius" )
		local location = self:GetCursorPosition()
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			location,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,friendly in pairs(targets) do
			-- Add modifier
			friendly:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_dazzle_shallow_grave_lua", -- modifier name
				{ duration = duration } -- kv
			)
		end
	else
		-- Single target when without scepter
		-- Add modifier
		self:GetCursorTarget():AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dazzle_shallow_grave_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
end