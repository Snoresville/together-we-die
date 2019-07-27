holdout_cm_arcane_aura_ability = class ({})

function IntManaRegen(event)
    local eCaster = event.caster
    local eTarget = event.target
    local eAbility = event.ability

    local intManaToRegen = (eCaster:GetIntellect() * eAbility:GetSpecialValueFor("int_multiplier"))

    eTarget:GiveMana(intManaToRegen)
end