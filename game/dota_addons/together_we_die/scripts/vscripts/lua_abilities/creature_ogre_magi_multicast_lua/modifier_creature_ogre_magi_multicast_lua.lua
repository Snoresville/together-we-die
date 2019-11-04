modifier_creature_ogre_magi_multicast_lua = class({})

modifier_creature_ogre_magi_multicast_lua.singles = {
	["creature_ogre_magi_fireblast_lua"] = true,
	["creature_ogre_magi_hex_lua"] = true,
}
--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_ogre_magi_multicast_lua:IsHidden()
	return false
end

function modifier_creature_ogre_magi_multicast_lua:IsDebuff()
	return false
end

function modifier_creature_ogre_magi_multicast_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_ogre_magi_multicast_lua:OnCreated( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100

	self.buffer_range = 300
end

function modifier_creature_ogre_magi_multicast_lua:OnRefresh( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100
end

function modifier_creature_ogre_magi_multicast_lua:OnRemoved()
end

function modifier_creature_ogre_magi_multicast_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_ogre_magi_multicast_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_creature_ogre_magi_multicast_lua:OnAbilityFullyCast( params )
	if params.unit~=self:GetCaster() then return end
	if params.ability==self:GetAbility() then return end

	-- cancel if break
	if self:GetCaster():PassivesDisabled() then return end

	-- only spells that have target
	if not params.target then return end

	-- if the spell can do both target and point, it should not trigger
	if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
	if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end

	-- Ensure it is not a passive ability
	if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE ) ~= 0 then return end

	-- roll multicasts
	local casts = 1
	if RandomInt( 0,100 ) < self.chance_2 then casts = 2 end
	if RandomInt( 0,100 ) < self.chance_3 then casts = 3 end
	if RandomInt( 0,100 ) < self.chance_4 then casts = 4 end

	-- check delay
	local delay = params.ability:GetSpecialValueFor( "multicast_delay" ) or 0

	-- only for fireblast multicast to single target
	local abilityName = params.ability:GetAbilityName()
	local single = self.singles[abilityName] or false

	if params.target then
		-- multicast
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_creature_ogre_magi_multicast_lua_proc", -- modifier name
			{
				ability = params.ability:entindex(),
				target = params.target:entindex(),
				multicast = casts,
				delay = delay,
				single = single,
			} -- kv
		)
	end
end