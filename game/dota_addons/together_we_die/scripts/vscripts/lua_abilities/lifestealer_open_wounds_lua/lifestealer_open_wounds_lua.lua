lifestealer_open_wounds_lua = class({})
LinkLuaModifier( "modifier_lifestealer_open_wounds_lua", "lua_abilities/lifestealer_open_wounds_lua/modifier_lifestealer_open_wounds_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function lifestealer_open_wounds_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function lifestealer_open_wounds_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

	local search = self:GetSpecialValueFor( "radius" )
	local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			target,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
	)

	for _,enemy in pairs(targets) do
		-- cancel if linken
		if not enemy:TriggerSpellAbsorb( self ) then
			-- add modifier
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_lifestealer_open_wounds_lua", -- modifier name
					{ duration = duration } -- kv
			)
		end
	end

	-- play effects
	local sound_cast = "Hero_LifeStealer.OpenWounds.Cast"
	local sound_target = "Hero_LifeStealer.OpenWounds"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
end