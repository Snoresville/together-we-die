modifier_wraith_king_mortal_strike_lua_spawn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_wraith_king_mortal_strike_lua_spawn:IsHidden()
	return true
end

function modifier_wraith_king_mortal_strike_lua_spawn:IsDebuff()
	return false
end

function modifier_wraith_king_mortal_strike_lua_spawn:IsStunDebuff()
	return false
end

function modifier_wraith_king_mortal_strike_lua_spawn:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_wraith_king_mortal_strike_lua_spawn:OnCreated( kv )
	-- references
	self.current_target = nil

	-- Start interval
	if IsServer() then
		self:StartIntervalThink( 0.5 )
		self:OnIntervalThink()
	end
end

function modifier_wraith_king_mortal_strike_lua_spawn:OnRefresh( kv )
	
end

function modifier_wraith_king_mortal_strike_lua_spawn:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_wraith_king_mortal_strike_lua_spawn:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_wraith_king_mortal_strike_lua_spawn:OnIntervalThink()
	if self.current_target == nil or EntIndexToHScript( self.current_target ) == nil or not EntIndexToHScript( self.current_target ):IsAlive() then
		-- Find Units in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			self:GetParent():MoveToTargetToAttack( enemy )
			self.current_target = enemy:entindex()
			break
		end
	end
end
