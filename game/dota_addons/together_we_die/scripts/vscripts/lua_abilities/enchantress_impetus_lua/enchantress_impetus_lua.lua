enchantress_impetus_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function enchantress_impetus_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end
--------------------------------------------------------------------------------
function enchantress_impetus_lua:CastFilterResultTarget( hTarget )
	if IsServer() and hTarget ~= nil and hTarget.GetUnitName ~= nil then
		return UnitFilter(
					hTarget,
					self:GetAbilityTargetTeam(),
					self:GetAbilityTargetType(),
					self:GetAbilityTargetFlags(),
					self:GetCaster():GetTeamNumber()
				)
	end
	return UF_FAIL_OTHER
end
--------------------------------------------------------------------------------
-- AOE Radius
function enchantress_impetus_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
--------------------------------------------------------------------------------
-- Ability Start
function enchantress_impetus_lua:OnSpellStart()
end

function enchantress_impetus_lua:GetProjectileName()
	return "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
end

--------------------------------------------------------------------------------
-- Orb Effects
function enchantress_impetus_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_Enchantress.Impetus"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function enchantress_impetus_lua:OnOrbImpact( params )
	-- unit identifier
	local caster = self:GetCaster()
	local target = params.target

	-- load data
	local distance_cap = self:GetSpecialValueFor("distance_cap")
	local distance_dmg = self:GetSpecialValueFor("distance_damage_pct")
	local int_multiplier = self:GetSpecialValueFor("int_multiplier")
	
	-- calculate distance & damage
	local distance = math.min( (caster:GetOrigin()-target:GetOrigin()):Length2D(), distance_cap )
	local damage = distance_dmg/100 * distance * math.max(int_multiplier * self:GetCaster():GetIntellect(), 1) -- ensure it is always at least 1

	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
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
		-- apply damage
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end

	-- play effects
	local sound_cast = "Hero_Enchantress.ImpetusDamage"
	EmitSoundOn( sound_cast, target )
end