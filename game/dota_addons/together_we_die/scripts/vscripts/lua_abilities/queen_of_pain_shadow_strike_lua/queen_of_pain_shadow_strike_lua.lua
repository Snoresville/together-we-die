queen_of_pain_shadow_strike_lua = class({})
LinkLuaModifier( "modifier_queen_of_pain_shadow_strike_lua", "lua_abilities/queen_of_pain_shadow_strike_lua/modifier_queen_of_pain_shadow_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queen_of_pain_shadow_strike_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

-- Ability Start
function queen_of_pain_shadow_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Create Projectile
	local projectile_name = "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	local search = self:GetSpecialValueFor( "radius" )
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(targets) do
		local info = {
			Target = enemy,
			Source = caster,
			Ability = self,	
			EffectName = projectile_name,
			iMoveSpeed = projectile_speed,
			bReplaceExisting = false,                         -- Optional
			bProvidesVision = false,                           -- Optional
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

	
	-- Play effects
	local sound_cast = "Hero_QueenOfPain.ShadowStrike"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function queen_of_pain_shadow_strike_lua:OnProjectileHit( target, location )
	if target==nil or target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
		return
	end

	local debuffDuration = self:GetDuration()
	
	-- Add modifier
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_queen_of_pain_shadow_strike_lua", -- modifier name
		{ duration = debuffDuration } -- kv
	)	
end

--------------------------------------------------------------------------------
-- Ability Considerations
function queen_of_pain_shadow_strike_lua:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end