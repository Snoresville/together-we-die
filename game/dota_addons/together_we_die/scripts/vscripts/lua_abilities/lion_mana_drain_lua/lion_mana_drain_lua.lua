-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
lion_mana_drain_lua = class({})
LinkLuaModifier( "modifier_lion_mana_drain_lua", "lua_abilities/lion_mana_drain_lua/modifier_lion_mana_drain_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
lion_mana_drain_lua.modifiers = {}
-- AOE Radius
function lion_mana_drain_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function lion_mana_drain_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		target,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MANA_ONLY,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(targets) do
		-- cancel if linken
		if not enemy:TriggerSpellAbsorb( self ) then
			-- register modifier (in case for multi-target)
			local modifier = enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_lion_mana_drain_lua", -- modifier name
				{ duration = duration } -- kv
			)
			self.modifiers[modifier] = true
		end
	end

	-- play effects
	self.sound_cast = "Hero_Lion.ManaDrain"
	EmitSoundOn( self.sound_cast, caster )
end

function lion_mana_drain_lua:Unregister( modifier )
	-- unregister modifier
	self.modifiers[modifier] = nil

	-- check if there are no modifier left
	local counter = 0
	for modifier,_ in pairs(self.modifiers) do
		if not modifier:IsNull() then
			counter = counter+1
		end
	end

	-- stop draining if no other target exist
	if counter==0 then
		-- destroy all modifier
		for modifier,_ in pairs(self.modifiers) do
			if not modifier:IsNull() then
				modifier.forceDestroy = bInterrupted
				modifier:Destroy()
			end
		end
		self.modifiers = {}

		-- end sound
		StopSoundOn( self.sound_cast, self:GetCaster() )
	end
end