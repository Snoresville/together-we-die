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
viper_poison_attack_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_poison_attack_lua", "lua_abilities/viper_poison_attack_lua/modifier_viper_poison_attack_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function viper_poison_attack_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function viper_poison_attack_lua:CastFilterResultTarget( hTarget )
	if hTarget ~= nil and hTarget.GetUnitName ~= nil then
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

-- AOE Radius
function viper_poison_attack_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


--------------------------------------------------------------------------------
-- Orb Effects
function viper_poison_attack_lua:GetProjectileName()
	return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end

function viper_poison_attack_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "hero_viper.poisonAttack.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function viper_poison_attack_lua:OnOrbImpact( params )
	-- references
	local duration = self:GetSpecialValueFor( "duration" )

	local enemies = FindUnitsInRadius( 
		self:GetCaster():GetTeamNumber(), 
		params.target:GetOrigin(), 
		params.target, 
		self:GetSpecialValueFor( "radius" ), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 
		0, 
		false 
	)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsInvulnerable() ) then
				enemy:AddNewModifier(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_viper_poison_attack_lua", -- modifier name
					{ duration = duration } -- kv
				)

				-- play effects
				local sound_cast = "hero_viper.poisonAttack.Target"
				EmitSoundOn( sound_cast, enemy )
			end
		end
	end
end