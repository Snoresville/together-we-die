LinkLuaModifier("modifier_spectre_einherjar_lua", "lua_abilities/spectre_einherjar_lua/modifier_spectre_einherjar_lua.lua", LUA_MODIFIER_MOTION_NONE)

spectre_einherjar_lua = class({})

function spectre_einherjar_lua:OnSpellStart()
    local caster = self:GetCaster()
    local spawn_location = caster:GetOrigin()
    local duration = self:GetSpecialValueFor("duration")
    local illusion_damage_incoming = self:GetSpecialValueFor("illusion_damage_incoming")
    local illusion_damage_outgoing = self:GetSpecialValueFor("illusion_damage_outgoing")
    if caster:HasScepter() then
        illusion_damage_incoming = self:GetSpecialValueFor("scepter_illusion_damage_incoming")
    end

    local modifyEinherjar = function(illusion)
        -- set facing
        illusion:SetForwardVector(caster:GetForwardVector())

        -- set level, abilities and items
        while illusion:GetLevel() < caster:GetLevel() do
            illusion:HeroLevelUp(false)
        end
        illusion:SetAbilityPoints(0)
        local abilityCount = caster:GetAbilityCount()
        for i = 0, abilityCount - 1 do
            local ability = caster:GetAbilityByIndex(i)
            if ability then
                local abilityLevel = ability:GetLevel()
                if illusion:GetAbilityByIndex(i) then
                    illusion:GetAbilityByIndex(i):SetLevel(abilityLevel)
                else
                    -- Add ability
                    local abilityName = ability:GetAbilityName()
                    local newAbility = illusion:AddAbility(abilityName)
                    newAbility:SetLevel(abilityLevel)
                end
            end
        end
        local eslot = nil
        for slot = 0, 5 do
            -- remove anything in current slot
            local iItem = illusion:GetItemInSlot(slot)
            if iItem then
                illusion:RemoveItem(illusion:GetItemInSlot(slot))
            end

            -- add item to slot
            local item = caster:GetItemInSlot(slot)
            if item then
                illusion:AddItemByName(item:GetName())

                -- rearrange slot
                if eslot and eslot ~= slot then
                    illusion:SwapItems(eslot, slot)
                end
            elseif not eslot then
                eslot = slot
            end
        end

        -- make illusion
        illusion:MakeIllusion()
        illusion:SetControllableByPlayer(caster:GetPlayerID(), false) -- (playerID, bSkipAdjustingPosition)
        illusion:SetPlayerID(caster:GetPlayerID())

        -- Add illusion modifier
        illusion:AddNewModifier(
                caster,
                self,
                "modifier_illusion",
                {
                    duration = duration,
                    outgoing_damage = illusion_damage_outgoing,
                    incoming_damage = illusion_damage_incoming,
                }
        )

        illusion:AddNewModifier(caster, self, "modifier_spectre_einherjar_lua", {})
    end

    -- Create unit
    CreateUnitByNameAsync(
            caster:GetUnitName(), -- szUnitName
            spawn_location, -- vLocation,
            true, -- bFindClearSpace,
            caster, -- hNPCOwner,
            caster:GetPlayerOwner(), -- hUnitOwner,
            caster:GetTeamNumber(), -- iTeamNumber
            modifyEinherjar
    )

    -- Play sound effects
    local sound_cast = "Hero_Spectre.Haunt"
    EmitSoundOn(sound_cast, caster)
end
