item_card_point_book_lua = class({})

-- Ability Start
function item_card_point_book_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local cardPointsToGive = self:GetSpecialValueFor("card_points")

    if caster:IsHero() and caster:IsRealHero() and not caster:IsIllusion() then
        local nPlayerID = caster:GetPlayerID()
        local player = PlayerResource:GetPlayer(nPlayerID)
        local playerHero = player:GetAssignedHero()
        if caster == playerHero then
            holdout_card_points:_BuyCardPoints(caster:GetPlayerID(), cardPointsToGive)
        end

        -- Consume one charge
        self:SpendCharge()
    end
end