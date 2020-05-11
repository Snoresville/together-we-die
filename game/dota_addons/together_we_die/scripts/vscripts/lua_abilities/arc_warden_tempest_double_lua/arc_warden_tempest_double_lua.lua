LinkLuaModifier( "modifier_arc_warden_tempest_double_lua", "lua_abilities/arc_warden_tempest_double_lua/modifier_arc_warden_tempest_double_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_tempest_double_lua_permanent", "lua_abilities/arc_warden_tempest_double_lua/modifier_arc_warden_tempest_double_lua_permanent.lua", LUA_MODIFIER_MOTION_NONE )

arc_warden_tempest_double_lua = class({})

function arc_warden_tempest_double_lua:GetManaCost()
	return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_cost") / 100)
end

function arc_warden_tempest_double_lua:OnSpellStart()
	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()
	local health_cost = self:GetSpecialValueFor("health_cost") / 100
	local duration = self:GetSpecialValueFor("duration")
	local hasScepter = caster:HasScepter()

	-- health cost
	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = math.ceil(caster:GetHealth() * health_cost),
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
	}
	ApplyDamage(damageTable)

	local modifyDouble = function ( double )
		double:SetControllableByPlayer( caster:GetPlayerID(), false )
		double:SetPlayerID( caster:GetPlayerID() )

		local caster_level = caster:GetLevel()
		for i = 2, caster_level do
			double:HeroLevelUp(false)
		end

		local maxAbilities = caster:GetAbilityCount() - 1

		for ability_id = 0, maxAbilities do
			local ability = caster:GetAbilityByIndex(ability_id)
			if ability then
				local doubleAbility = double:GetAbilityByIndex(ability_id)
				local abilityLevel = ability:GetLevel()
				if doubleAbility then
					doubleAbility:SetLevel(abilityLevel)
					if doubleAbility:GetName() == "arc_warden_tempest_double_lua" then
						doubleAbility:SetActivated(false)
					end
				else
					-- Add ability
					local abilityName = ability:GetAbilityName()
					local newAbility = double:AddAbility(abilityName)
					newAbility:SetLevel(abilityLevel)

					if newAbility:GetName() == "arc_warden_tempest_double_lua" then
						newAbility:SetActivated(false)
					end
				end
			end
		end


		for item_id = 0, 5 do
			local item_in_caster = caster:GetItemInSlot(item_id)
			if item_in_caster ~= nil then
				local item_name = item_in_caster:GetName()
				if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_ward_observer" or item_name == "item_ward_sentry" or item_name == "item_rapier" or item_name == "item_recipe_rapier" or item_name == "item_dredged_trident" or item_name == "item_recipe_dredged_trident") then
					local item_created = CreateItem( item_in_caster:GetName(), double, double)
					double:AddItem(item_created)
					item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges()) 
				end
			end
		end

		double:SetHealth(caster:GetHealth())
		double:SetMana(caster:GetMana())

		double:SetMaximumGoldBounty(0)
		double:SetMinimumGoldBounty(0)
		double:SetDeathXP(0)
		double:SetAbilityPoints(0) 

		double:SetHasInventory(false)
		double:SetCanSellItems(false)

		double:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_lua_permanent", {})
		double:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_lua", {
			duration = duration
		})
		if hasScepter then
			double:AddNewModifier(caster, self, "modifier_item_ultimate_scepter_consumed", nil)
		end
	end

	-- Create unit
	local double = CreateUnitByNameAsync(
		caster:GetUnitName(), -- szUnitName
		spawn_location, -- vLocation,
		true, -- bFindClearSpace,
		caster, -- hNPCOwner,
		caster:GetPlayerOwner(), -- hUnitOwner,
		caster:GetTeamNumber(), -- iTeamNumber
		modifyDouble
	)

	-- Play sound effects
	local sound_cast = "Hero_ArcWarden.TempestDouble"
	EmitSoundOn( sound_cast, caster )
end
