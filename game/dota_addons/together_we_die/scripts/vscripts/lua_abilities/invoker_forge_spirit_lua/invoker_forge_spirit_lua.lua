invoker_forge_spirit_lua = class({})
LinkLuaModifier( "modifier_invoker_forge_spirit_lua", "lua_abilities/invoker_forge_spirit_lua/modifier_invoker_forge_spirit_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function invoker_forge_spirit_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local caster_intellect = caster:GetIntellect()
	local spirit_damage = self:GetOrbSpecialValueFor( "spirit_damage", "e" ) + caster_intellect * self:GetOrbSpecialValueFor( "damage_int_multiplier", "e" )
	local health = self:GetOrbSpecialValueFor( "spirit_hp", "q" ) + caster_intellect * self:GetOrbSpecialValueFor( "health_int_multiplier", "q" )
	local mana = self:GetOrbSpecialValueFor( "spirit_mana", "e" )
	local armor = self:GetOrbSpecialValueFor( "spirit_armor", "e" )
	local attack_range = self:GetOrbSpecialValueFor( "spirit_attack_range", "q" )
	local duration = self:GetOrbSpecialValueFor( "spirit_duration", "q" )

	local forged_spirit = CreateUnitByName( "npc_dota_invoker_forged_spirit", caster:GetOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber() )
	if forged_spirit ~= nil then
		forged_spirit:SetControllableByPlayer( caster:GetPlayerID(), false )
		forged_spirit:SetOwner( caster )
		forged_spirit:SetBaseDamageMax( spirit_damage )
		forged_spirit:SetBaseDamageMin( spirit_damage )
		forged_spirit:SetBaseMaxHealth( health )
		forged_spirit:SetMaxMana( mana )
		forged_spirit:SetMana( mana )
		forged_spirit:SetPhysicalArmorBaseValue( armor )
		forged_spirit:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

		local kv = {
			duration = duration,
			attack_range = attack_range,
		}

		forged_spirit:AddNewModifier( caster, self, "modifier_invoker_forge_spirit_lua", kv )
	end

	EmitSoundOnLocationWithCaster( caster:GetOrigin(), "Hero_Invoker.ForgeSpirit", caster )
end