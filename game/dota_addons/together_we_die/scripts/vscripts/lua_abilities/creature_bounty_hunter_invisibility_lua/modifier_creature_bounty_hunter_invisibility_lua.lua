modifier_creature_bounty_hunter_invisibility_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_bounty_hunter_invisibility_lua:IsHidden()
	return true
end

function modifier_creature_bounty_hunter_invisibility_lua:IsDebuff()
	return false
end

function modifier_creature_bounty_hunter_invisibility_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_bounty_hunter_invisibility_lua:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	-- Start interval
	if not IsServer() then return end
	local interval = 1
	self:OnIntervalThink()
	self:StartIntervalThink( interval )
end

function modifier_creature_bounty_hunter_invisibility_lua:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_creature_bounty_hunter_invisibility_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- OnThink
function modifier_creature_bounty_hunter_invisibility_lua:OnIntervalThink()
	local bounty_hunter = self:GetParent()
	if bounty_hunter:IsAlive() and not bounty_hunter:PassivesDisabled() and self:GetAbility():IsFullyCastable() then
		bounty_hunter:AddNewModifier(
			bounty_hunter, -- player source
			self:GetAbility(), -- ability source
			"modifier_creature_bounty_hunter_invisibility_lua_buff", -- modifier name
			{
				duration = self.duration,
			}
		)

		-- cooldown
		self:GetAbility():UseResources( false, false, true )

		local enemies = FindUnitsInRadius(
			bounty_hunter:GetTeamNumber(),	-- int, your team number
			bounty_hunter:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			self:GetParent():MoveToTargetToAttack( enemy )
			break
		end
	end
end
