item_card_point_book_lua = class({})

-- Ability Start
function item_card_point_book_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local cardPointsToGive = self:GetSpecialValueFor("card_points")
    local cardPointAbility
    local cardPoints = 0

    if caster:IsRealHero() then
        -- check for card points and retrieve
        if caster:HasAbility("card_points_lua") then
            cardPointAbility = caster:FindAbilityByName("card_points_lua")
            cardPoints = cardPointAbility:GetCP()
        else
            cardPointAbility = caster:AddAbility("card_points_lua")
            cardPointAbility:SetLevel(1)
        end

        cardPointAbility:SetCP(cardPoints + cardPointsToGive)

        -- Consume one charge
        self:SpendCharge()
    end
end