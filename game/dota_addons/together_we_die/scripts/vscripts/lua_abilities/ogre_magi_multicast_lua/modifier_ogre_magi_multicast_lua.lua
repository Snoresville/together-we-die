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
modifier_ogre_magi_multicast_lua = class({})
modifier_ogre_magi_multicast_lua.singles = {
	["ogre_magi_fireblast_lua"] = true,
	["ogre_magi_unrefined_fireblast_lua"] = true,
	["ogre_magi_fireblast"] = true,
	["ogre_magi_unrefined_fireblast"] = true,
}
modifier_ogre_magi_multicast_lua.banned = {
	["item_blink"] = true,
	["holdout_qop_blink"] = true,
	["item_tpscroll"] = true,
	["item_travel_boots"] = true,
	["item_travel_boots_2"] = true,
}

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_multicast_lua:IsHidden()
	return false
end

function modifier_ogre_magi_multicast_lua:IsDebuff()
	return false
end

function modifier_ogre_magi_multicast_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_multicast_lua:OnCreated( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100

	self.buffer_range = 300
end

function modifier_ogre_magi_multicast_lua:OnRefresh( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100
end

function modifier_ogre_magi_multicast_lua:OnRemoved()
end

function modifier_ogre_magi_multicast_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ogre_magi_multicast_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_ogre_magi_multicast_lua:OnAbilityFullyCast( params )
	if params.unit~=self:GetCaster() then return end
	if params.ability==self:GetAbility() then return end

	-- cancel if break
	if self:GetCaster():PassivesDisabled() then return end

	-- only spells that have target
	-- if not params.target then return end

	-- check if spell is banned
	local abilityName = params.ability:GetAbilityName()
	if self.banned[abilityName] then return end

	-- if the spell can do both target and point, it should not trigger
	--if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
	--if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end

	-- roll multicasts
	local casts = 1
	if RandomInt( 0,100 ) < self.chance_2 then casts = 2 end
	if RandomInt( 0,100 ) < self.chance_3 then casts = 3 end
	if RandomInt( 0,100 ) < self.chance_4 then casts = 4 end

	-- check delay
	local delay = params.ability:GetSpecialValueFor( "multicast_delay" ) or 0

	-- only for fireblast multicast to single target
	local single = self.singles[abilityName] or false

	if params.target then
		-- multicast
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_ogre_magi_multicast_lua_proc", -- modifier name
			{
				ability = params.ability:entindex(),
				target = params.target:entindex(),
				targetPoint = false,
				multicast = casts,
				delay = delay,
				single = single,
			} -- kv
		)
	else
		if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then
			-- multicast point based spell
			self:GetCaster():AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_ogre_magi_multicast_lua_proc", -- modifier name
				{
					ability = params.ability:entindex(),
					target_point = true,
					multicast = casts,
					delay = delay,
					single = single,
				} -- kv
			)
		else
			-- Don't allow non-targetting items as spells purchased can be activated
			if params.ability:IsItem() then return end

			self:GetCaster():AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_ogre_magi_multicast_lua_self_cast_proc", -- modifier name
				{
					ability = params.ability:entindex(),
					multicast = casts,
					delay = delay,
				} -- kv
			)
		end
	end
end