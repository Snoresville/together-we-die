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
        end


        -- Does the player already have the ability requested?
        if playerHero:HasAbility(abilityName) then
            -- Trying to refund
            local existingAbility = playerHero:FindAbilityByName(abilityName)
            local spellLevel = existingAbility:GetLevel()
            if spellLevel ~= 0 then
                -- Refund ability points spent
                local abilityPointsToSet = playerHero:GetAbilityPoints() + spellLevel
                playerHero:SetAbilityPoints(abilityPointsToSet)
            end
            playerHero:RemoveAbility(abilityName)

            -- Refund the card points
            cardPointAbility:SetCP(cardPoints + abilityCost)
            Notifications:Top(nPlayerID, {text="#DOTA_HUD_Spells_Menu_Successful_Refund", duration=4, style={color="green"}})
            CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", {}); -- Close the menu
        else
            -- Trying to buy
            if cardPoints >= abilityCost then
                playerHero:AddAbility(abilityName)
                -- Deduct card points
                cardPointAbility:SetCP(cardPoints - abilityCost)
                Notifications:Top(nPlayerID, {text="#DOTA_HUD_Spells_Menu_Successful_Purchase", duration=4, style={color="green"}})
                CustomGameEventManager:Send_ServerToPlayer(player, "spells_menu_buy_spell_feedback", {}); -- Close the menu
            else
                Notifications:Top(nPlayerID, {text="#DOTA_HUD_Spells_Menu_Insufficient_CP", duration=4, style={color="red"}})
            end
        end
    end
end