item_card_point_book_lua = class({})

-- Ability Start
function item_card_point_book_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local cardPointsToGive = self:GetSpecialValueFor("card_points")

    if caster:IsRealHero() then
        holdout_card_points:_BuyCardPoints(caster:GetPlayerID(), cardPointsToGive)
        -- Consume one charge
        self:SpendCharge()
    end
end