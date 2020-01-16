antimage_blink_lua = class({})

--------------------------------------------------------------------------------
-- Ability Start
function antimage_blink_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local origin = caster:GetOrigin()

    -- load data
    local max_range = self:GetSpecialValueFor("blink_range") + caster:GetAgility() * self:GetSpecialValueFor("agi_multiplier")

    -- determine target position
    local direction = (point - origin)
    if direction:Length2D() > max_range then
        direction = direction:Normalized() * max_range
    end

    -- create illusion
    self:CreateIllusionOnOrigin(origin)

    -- teleport
    FindClearSpaceForUnit(caster, origin + direction, true)

    -- Play effects
    self:PlayEffects(origin, direction)
end

--------------------------------------------------------------------------------
function antimage_blink_lua:PlayEffects(origin, direction)
    -- Get Resources
    local particle_cast_a = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
    local sound_cast_a = "Hero_Antimage.Blink_out"

    local particle_cast_b = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
    local sound_cast_b = "Hero_Antimage.Blink_in"

    -- At original position
    local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(effect_cast_a, 0, origin)
    ParticleManager:SetParticleControlForward(effect_cast_a, 0, direction:Normalized())
    ParticleManager:ReleaseParticleIndex(effect_cast_a)
    EmitSoundOnLocationWithCaster(origin, sound_cast_a, self:GetCaster())

    -- At original position
    local effect_cast_b = ParticleManager:CreateParticle(particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(effect_cast_b, 0, self:GetCaster():GetOrigin())
    ParticleManager:SetParticleControlForward(effect_cast_b, 0, direction:Normalized())
    ParticleManager:ReleaseParticleIndex(effect_cast_b)
    EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), sound_cast_b, self:GetCaster())
end
--------------------------------------------------------------------------------
function antimage_blink_lua:CreateIllusionOnOrigin(origin)
    local caster = self:GetCaster()
    local illusion_duration = self:GetSpecialValueFor("illusion_duration")
    local illusion_outgoing_damage = self:GetSpecialValueFor("illusion_outgoing_damage")
    local illusion_incoming_damage = self:GetSpecialValueFor("illusion_incoming_damage")

    local modifyIllusion = function(illusion)
        illusion:SetControllableByPlayer(caster:GetPlayerID(), false)
        illusion:SetPlayerID(caster:GetPlayerID())

        -- Set the unit as an illusion
        -- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
        illusion:AddNewModifier(caster, self, "modifier_illusion", { duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage })
        -- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
        illusion:MakeIllusion()

        -- Level Up the unit to the casters level
        local casterLevel = caster:GetLevel()
        for i = 2, casterLevel do
            illusion:HeroLevelUp(false)
        end

        -- Set the skill points to 0 and learn the skills of the caster
        illusion:SetAbilityPoints(0)

        local maxAbilities = caster:GetAbilityCount() - 1

        for ability_id = 0, maxAbilities do
            local ability = caster:GetAbilityByIndex(ability_id)
            if ability then
                local abilityLevel = ability:GetLevel()
                if abilityLevel ~= 0 then
                    local illusionAbility = illusion:GetAbilityByIndex(ability_id)
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
        end

        -- Recreate the items of the caster
        for itemSlot = 0, 5 do
            local item = caster:GetItemInSlot(itemSlot)
            if item ~= nil then
                local itemName = item:GetName()
                local newItem = CreateItem(itemName, illusion, illusion)
                illusion:AddItem(newItem)
            end
        end
    end

    -- Create unit
    CreateUnitByNameAsync(
            caster:GetUnitName(), -- szUnitName
            origin, -- vLocation,
            true, -- bFindClearSpace,
            caster, -- hNPCOwner,
            caster:GetPlayerOwner(), -- hUnitOwner,
            caster:GetTeamNumber(), -- iTeamNumber
            modifyIllusion
    )
end