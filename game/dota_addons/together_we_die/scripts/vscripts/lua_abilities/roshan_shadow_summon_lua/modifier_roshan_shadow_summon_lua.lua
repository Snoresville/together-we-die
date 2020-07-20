modifier_roshan_shadow_summon_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_shadow_summon_lua:IsHidden()
    return self:GetParent():GetHealthPercent() > self.hp_percent
end

function modifier_roshan_shadow_summon_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_shadow_summon_lua:OnCreated(kv)
    -- references
    self.invulnerability_duration = self:GetAbility():GetSpecialValueFor("invulnerability_duration")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
    local interval = 1.0

    if IsServer() then
        self:StartIntervalThink(interval)
    end
end

function modifier_roshan_shadow_summon_lua:OnRefresh(kv)
    -- references
    self.invulnerability_duration = self:GetAbility():GetSpecialValueFor("invulnerability_duration")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
end

function modifier_roshan_shadow_summon_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_shadow_summon_lua:OnIntervalThink()
    local roshan = self:GetParent()
    local canCast = roshan:GetHealthPercent() <= self.hp_percent
    if roshan:IsAlive() and not roshan:PassivesDisabled() and canCast and self:GetAbility():IsFullyCastable() then
        local fv = roshan:GetForwardVector()
        local origin = roshan:GetAbsOrigin()
        local frontPosition = origin + fv * 200
        local summonCount = 2

        local ancient = Entities:FindByName(nil, "dota_goodguys_fort")
        local easy_difficulty_modifier = ancient:FindAbilityByName("easy_difficulty_lua")
        local impossible_difficulty_modifier = ancient:FindAbilityByName("impossible_difficulty_lua")
        -- Easy mode? Summon less
        if easy_difficulty_modifier then
            summonCount = summonCount - 1
        end
        -- Impossible mode? Summon more
        if impossible_difficulty_modifier then
            summonCount = summonCount + 1
        end

        local summonShadowCreature = function(shadowCreature)
            if shadowCreature ~= nil then
                shadowCreature:SetOwner(roshan)
                shadowCreature:SetForwardVector(fv)
            end
        end

        for i = 1, summonCount do
            local rotatePos = RotatePosition(origin, QAngle(0, i / summonCount * 360, 0), frontPosition)
            -- Create unit
            CreateUnitByNameAsync(
                    "npc_dota_creature_boss_dark_willow", -- szUnitName
                    rotatePos, -- vLocation,
                    true, -- bFindClearSpace,
                    roshan, -- hNPCOwner,
                    roshan:GetPlayerOwner(), -- hUnitOwner,
                    roshan:GetTeamNumber(), -- iTeamNumber
                    summonShadowCreature
            )
        end

        roshan:AddNewModifier(
                roshan, -- player source
                self:GetAbility(), -- ability source
                "modifier_roshan_shadow_summon_invulnerable_lua", -- modifier name
                {
                    duration = self.invulnerability_duration
                } -- kv
        )

        self:GetAbility():UseResources(false, false, true)
    end
end