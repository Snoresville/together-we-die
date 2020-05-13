holdout_card_points = class({})

function holdout_card_points:Init()
    CustomGameEventManager:RegisterListener("spells_menu_buy_spell", function(...)
        return self:_SpellsMenuBuySpell(...)
    end)

end

function holdout_card_points:_SpellsMenuBuySpell(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local abilityName = event_data.spell_id
    local abilityCost = event_data.cost
    local associatedAbilities = event_data.associated_spells
    local associatedLearnables = event_data.associated_learnables

    if PlayerResource:HasSelectedHero(nPlayerID) then
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()
        local cardPoints = 0
        local cardPointAbility;

        -- check for card points and retrieve
        if playerHero:HasAbility("card_points_lua") then
            cardPointAbility = playerHero:FindAbilityByName("card_points_lua")
            cardPoints = cardPointAbility:GetCP()
        else
            cardPointAbility = playerHero:AddAbility("card_points_lua")
            cardPointAbility:SetLevel(1)
            cardPointAbility:MarkAbilityButtonDirty()
        end


        -- Does the player already have the ability requested?
        if playerHero:HasAbility(abilityName) then
            -- Trying to refund
            local existingAbility = playerHero:FindAbilityByName(abilityName)
            local spellLevel = existingAbility:GetLevel()
            local abilityPointsToSet = playerHero:GetAbilityPoints()
            if spellLevel ~= 0 then
                -- IF it is a learnable ability, refund ability points spent
                if not (bit.band(existingAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) ~= 0) then
                    abilityPointsToSet = abilityPointsToSet + spellLevel
                end
            end
            playerHero:RemoveAbilityByHandle(existingAbility)
            if associatedAbilities then
                -- Remove associated abilities
                for _, associatedAbilityName in pairs(associatedAbilities) do
                    playerHero:RemoveAbility(associatedAbilityName)
                end
            end
            if associatedLearnables then
                -- Remove associated learnables
                for _, associatedLearnableName in pairs(associatedLearnables) do
                    -- refund points
                    local learnableAbility = playerHero:FindAbilityByName(associatedLearnableName)
                    -- IF it is a learnable ability, refund ability points spent
                    if not (bit.band(learnableAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) ~= 0) then
                        abilityPointsToSet = abilityPointsToSet + learnableAbility:GetLevel()
                    end
                    playerHero:RemoveAbilityByHandle(learnableAbility)
                end
            end
            playerHero:SetAbilityPoints(abilityPointsToSet)
            playerHero:CalculateStatBonus()
            CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", {})

            -- Refund the card points
            cardPointAbility:SetCP(cardPoints + abilityCost)
            Notifications:Top(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Successful_Refund", duration = 4, style = { color = "green" } })
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", {}) -- Close the menu
        else
            -- Trying to buy
            if cardPoints >= abilityCost then
                local newAbility = playerHero:AddAbility(abilityName)
                if bit.band(newAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) ~= 0 then
                    newAbility:SetLevel(1)
                else
                    newAbility:SetLevel(0)
                end
                newAbility:MarkAbilityButtonDirty()
                if associatedAbilities then
                    -- Add associated abilities
                    for _, associatedAbilityName in pairs(associatedAbilities) do
                        local associatedAbility = playerHero:AddAbility(associatedAbilityName)
                        associatedAbility:MarkAbilityButtonDirty()
                    end
                end
                if associatedLearnables then
                    -- Add associated learnable
                    for _, associatedLearnableName in pairs(associatedLearnables) do
                        local associatedLearnable = playerHero:AddAbility(associatedLearnableName)
                        associatedLearnable:MarkAbilityButtonDirty()
                    end
                end
                playerHero:CalculateStatBonus()
                CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", {})
                -- Deduct card points
                cardPointAbility:SetCP(cardPoints - abilityCost)
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Successful_Purchase", duration = 4, style = { color = "green" } })
                CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", {}) -- Close the menu
            else
                Notifications:Top(nPlayerID, { text = "#DOTA_HUD_Spells_Menu_Insufficient_CP", duration = 4, style = { color = "red" } })
            end
        end
    end
end