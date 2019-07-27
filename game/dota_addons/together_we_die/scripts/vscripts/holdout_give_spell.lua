holdout_give_spell = class ({})

function GiveSpell(event)
    local eCaster = event.caster
    local eAbility = event.ability
    local spellName = event.spell_name_to_give

    if eCaster:IsHero() then
        if eCaster:HasAbility(spellName) then
            local existingSpell = eCaster:FindAbilityByName(spellName)
            local spellLevel = existingSpell:GetLevel()
            if spellLevel ~= 0 then
                if spellName == "special_bonus_unique_medusa_4" then
                    -- Don't refund
                else
                    -- Refund ability points spent
                    local abilityPointsToSet = eCaster:GetAbilityPoints() + spellLevel
                    eCaster:SetAbilityPoints(abilityPointsToSet)
                end
                
            end
    
            eCaster:RemoveAbility(spellName)
        else
            local newAbility = eCaster:AddAbility(spellName)

            if spellName == "special_bonus_unique_medusa_4" then
                newAbility:SetLevel(1)
            end
        end
    else
        
    end
end