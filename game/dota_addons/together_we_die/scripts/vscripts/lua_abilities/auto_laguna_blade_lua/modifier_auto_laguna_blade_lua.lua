modifier_auto_laguna_blade_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_auto_laguna_blade_lua:IsHidden()
	return true
end

function modifier_auto_laguna_blade_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_auto_laguna_blade_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_auto_laguna_blade_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_auto_laguna_blade_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_auto_laguna_blade_lua:OnIntervalThink()
	if not IsServer() then return end

	local modifierParent = self:GetParent()
	local selfAbility = self:GetAbility()
	if modifierParent:IsAlive() and not modifierParent:PassivesDisabled() and selfAbility:IsCooldownReady() then
		local lagunaBlade = modifierParent:FindAbilityByName( "lina_laguna_blade_lua" )
		if (lagunaBlade) then
			local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
			local targetType = lagunaBlade:GetAbilityTargetType()
			local targetFlags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE 
			if bit.band( lagunaBlade:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
				targetFlags = targetFlags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			end

			local units = FindUnitsInRadius(
				modifierParent:GetTeamNumber(),	-- int, your team number
				modifierParent:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				targetTeam,	-- int, team filter
				targetType,	-- int, type filter
				targetFlags,	-- int, flag filter
				FIND_CLOSEST,	-- int, order filter
				false	-- bool, can grow cache
			)

			for _,unit in pairs(units) do
				if unit:IsAlive() and not unit:IsNull() then
					modifierParent:SetCursorCastTarget( unit )
					lagunaBlade:OnSpellStart()
					-- cooldown
					selfAbility:UseResources( false, false, true )
					break
				end
			end
		end
	end
end