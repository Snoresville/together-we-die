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
modifier_drow_ranger_multishot_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_multishot_lua:IsHidden()
	return true
end

function modifier_drow_ranger_multishot_lua:IsPurgable()
	return false
end

function modifier_drow_ranger_multishot_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_drow_ranger_multishot_lua:OnCreated( kv )
	-- references
	self.damage_modifier = self:GetAbility():GetSpecialValueFor( "damage_modifier" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "multi_shot_bonus_range" )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )

	self.parent = self:GetParent()

	self.use_modifier = true

	if not IsServer() then return end
	self.projectile_name = self.parent:GetRangedProjectileName()
	self.projectile_speed = self.parent:GetProjectileSpeed()
end

function modifier_drow_ranger_multishot_lua:OnRefresh( kv )
	-- references
	self.damage_modifier = self:GetAbility():GetSpecialValueFor( "damage_modifier" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "multi_shot_bonus_range" )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	if not IsServer() then return end
end

function modifier_drow_ranger_multishot_lua:OnRemoved()
end

function modifier_drow_ranger_multishot_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_multishot_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_drow_ranger_multishot_lua:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self.parent then return end

	-- not proc for instant attacks
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if break
	if self.parent:PassivesDisabled() then return end

	-- not proc if on cooldown
	if not self:GetAbility():IsFullyCastable() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on multi shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.multi_shot then return end

	-- multi shot shot
	if self.use_modifier then
		self:SplitShotModifier( params.target )
	else
		self:SplitShotNoModifier( params.target )
	end

	-- cooldown
	self:GetAbility():UseResources( false, false, true )
end

function modifier_drow_ranger_multishot_lua:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	
	-- if uses modifier
	if self.multi_shot then
		return self.damage_modifier
	end

	-- if not use modifier
	if self:GetAbility().multi_shot_attack then
		return self.damage_modifier
	end
end

function modifier_drow_ranger_multishot_lua:GetModifierPreAttack_BonusDamage()
	if not IsServer() then return end

	local bonus_damage = self.agi_multiplier * self.parent:GetAgility()
	-- if uses modifier
	if self.multi_shot then
		return bonus_damage
	end

	-- if not use modifier
	if self:GetAbility().multi_shot_attack then
		return bonus_damage
	end
end
--------------------------------------------------------------------------------
-- Helper
--[[
	NOTE:
	- PerformAttack will use projectile particle from items, even if it actually not using attack modifiers
	- Split shot without attack modifier uses regular tracking projectile, then perform instant attacks on projectile hit
	- Therefore, SplitShotModifier and SplitShotNoModifier are separated JUST BECAUSE of projectile effects.
]]
function modifier_drow_ranger_multishot_lua:SplitShotModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			self.multi_shot = true
			self.parent:PerformAttack(
				enemy, -- hTarget
				false, -- bUseCastAttackOrb
				self.use_modifier, -- bProcessProcs
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)
			self.multi_shot = false
		end
	end

	-- play effects if splitshot
	local sound_cast = "Hero_Medusa.AttackSplit"
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_drow_ranger_multishot_lua:SplitShotNoModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then
			-- launch projectile
			local info = {
				Target = enemy,
				Source = self.parent,
				Ability = self:GetAbility(),	
				
				EffectName = self.projectile_name,
				iMoveSpeed = self.projectile_speed,
				bDodgeable = true,                           -- Optional
				-- bIsAttack = true,                                -- Optional
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end

	-- play effects if splitshot
	local sound_cast = "Hero_Medusa.AttackSplit"
	EmitSoundOn( sound_cast, self.parent )
end