modifier_windranger_focus_fire_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_windranger_focus_fire_lua:IsHidden()
	return false
end

function modifier_windranger_focus_fire_lua:IsDebuff()
	return false
end

function modifier_windranger_focus_fire_lua:IsPurgable()
	return false
end

function modifier_windranger_focus_fire_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_windranger_focus_fire_lua:OnCreated( kv )
	-- references
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.auto_interval = math.max(self:GetAbility():GetSpecialValueFor( "auto_interval" ) - self.int_multiplier * self:GetCaster():GetIntellect() / 50, 0.02)
	self.target_count = self:GetAbility():GetSpecialValueFor( "target_count" )
	if self:GetCaster():HasScepter() then
		self.target_count = self:GetAbility():GetSpecialValueFor( "scepter_target_count" )
	end

	self:StartIntervalThink( self.auto_interval )
	self:OnIntervalThink()
end

function modifier_windranger_focus_fire_lua:OnRefresh( kv )
	-- references
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.auto_interval = math.max(self:GetAbility():GetSpecialValueFor( "auto_interval" ) - self.int_multiplier * self:GetCaster():GetIntellect() / 50, 0.02)
	self.target_count = self:GetAbility():GetSpecialValueFor( "target_count" )
	if self:GetCaster():HasScepter() then
		self.target_count = self:GetAbility():GetSpecialValueFor( "scepter_target_count" )
	end

	self:StartIntervalThink( self.auto_interval )
end

function modifier_windranger_focus_fire_lua:OnRemoved()
end

function modifier_windranger_focus_fire_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_windranger_focus_fire_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_windranger_focus_fire_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_windranger_focus_fire_lua:OnIntervalThink()
	local parent = self:GetParent()
	local range = parent:Script_GetAttackRange()

	-- find other target units
	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),	-- int, your team number
		parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			parent:PerformAttack(
				enemy, -- hTarget
				true, -- bUseCastAttackOrb
				true, -- bProcessProcs use modifiers
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)

			count = count + 1
			if count>=self.target_count then break end
		end
	end
end