arc_warden_flux_lua = class({})
LinkLuaModifier( "modifier_arc_warden_flux_lua", "lua_abilities/arc_warden_flux_lua/modifier_arc_warden_flux_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function arc_warden_flux_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
-- Ability Start
function arc_warden_flux_lua:OnSpellStart()
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
		self:GetAbilityTargetTeam(),	-- int, team filter
		self:GetAbilityTargetType(),	-- int, type filter
		self:GetAbilityTargetFlags(),	-- int, flag filter
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
				"modifier_arc_warden_flux_lua", -- modifier name
				{ duration = duration } -- kv
			)
		end
	end

	-- effects
	local sound_cast = "Hero_ArcWarden.Flux.Cast"
	EmitSoundOn( sound_cast, caster )
end
