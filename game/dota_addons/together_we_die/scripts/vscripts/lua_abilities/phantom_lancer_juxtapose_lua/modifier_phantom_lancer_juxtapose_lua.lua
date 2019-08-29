modifier_phantom_lancer_juxtapose_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_lancer_juxtapose_lua:IsHidden()
	return true
end

function modifier_phantom_lancer_juxtapose_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_lancer_juxtapose_lua:OnCreated( kv )
	-- references
	local ability = self:GetAbility()
	local ability_name = ability:GetAbilityName()
	self.player = self:GetParent():GetPlayerID()
	self.original_hero = PlayerResource:GetSelectedHeroEntity(self.player)
	self.original_ability = self.original_hero:FindAbilityByName(ability_name)
	self.max_illusions = ability:GetSpecialValueFor( "max_illusions" )
	self.illusion_duration = ability:GetSpecialValueFor( "illusion_duration" )
	self.illusion_outgoing_damage = ability:GetSpecialValueFor( "illusion_outgoing_damage" )
	self.illusion_incoming_damage = ability:GetSpecialValueFor( "illusion_incoming_damage" )
	if self:GetParent():IsIllusion() then
		self.proc_chance = ability:GetSpecialValueFor( "illusion_proc_chance" )
	else
		self.proc_chance = ability:GetSpecialValueFor( "hero_proc_chance" )
	end
end

function modifier_phantom_lancer_juxtapose_lua:OnRefresh( kv )
	-- references
	local ability = self:GetAbility()
	self.max_illusions = ability:GetSpecialValueFor( "max_illusions" )
	self.illusion_duration = ability:GetSpecialValueFor( "illusion_duration" )
	self.illusion_outgoing_damage = ability:GetSpecialValueFor( "illusion_outgoing_damage" )
	self.illusion_incoming_damage = ability:GetSpecialValueFor( "illusion_incoming_damage" )
	if self:GetParent():IsIllusion() then
		self.proc_chance = ability:GetSpecialValueFor( "illusion_proc_chance" )
	else
		self.proc_chance = ability:GetSpecialValueFor( "hero_proc_chance" )
	end
end

function modifier_phantom_lancer_juxtapose_lua:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_lancer_juxtapose_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_phantom_lancer_juxtapose_lua:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				if self:RollChance( self.proc_chance ) and self.original_ability:GetSpawnedIllusionsCount() < self.max_illusions then
					local modifier_parent = self:GetParent()
					local unit_name = self.original_hero:GetUnitName()
					local origin = target:GetAbsOrigin() + RandomVector(100)
					-- handle_UnitOwner needs to be nil, else it will crash the game.
					local illusion = CreateUnitByName(unit_name, origin, true, modifier_parent, nil, modifier_parent:GetTeamNumber())
					illusion:SetPlayerID(self.player)
					illusion:SetControllableByPlayer(self.player, true)
				
					-- Level Up the unit to the casters level
					local casterLevel = self.original_hero:GetLevel()
					for i = 2, casterLevel do
						illusion:HeroLevelUp(false)
					end

					-- Set the skill points to 0 and learn the skills of the caster
					illusion:SetAbilityPoints(0)

					local maxAbilities = self.original_hero:GetAbilityCount()

					for ability_id = 0, maxAbilities do
						local ability = self.original_hero:GetAbilityByIndex(ability_id)
						if ability then
							local illusionAbility = illusion:GetAbilityByIndex(ability_id)
							local abilityLevel = ability:GetLevel()
							if illusionAbility then
								illusionAbility:SetLevel(abilityLevel)
							else
								-- Add ability
								local abilityName = ability:GetAbilityName()
								local newAbility = illusion:AddAbility(abilityName)
								newAbility:SetLevel(abilityLevel)
							end
						end
					end

					-- Recreate the items of the caster
					for itemSlot=0,5 do
						local item = self.original_hero:GetItemInSlot(itemSlot)
						if item ~= nil then
							local itemName = item:GetName()
							local newItem = CreateItem(itemName, illusion, illusion)
							illusion:AddItem(newItem)
						end
					end

					-- Set the unit as an illusion
					-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
					illusion:AddNewModifier(self.original_hero, self.original_ability, "modifier_illusion", { duration = self.illusion_duration, outgoing_damage = self.illusion_outgoing_damage, incoming_damage = self.illusion_incoming_damage })
					illusion:AddNewModifier(self.original_hero, self.original_ability, "modifier_phantom_lancer_juxtapose_illusion_lua", { duration = self.illusion_duration })
					-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
					illusion:MakeIllusion()

					self.original_ability:IncrementSpawnedIllusionsCount()
				end
			end
		end
	end
	
	return 0
end

--------------------------------------------------------------------------------
-- Helper
function modifier_phantom_lancer_juxtapose_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end
