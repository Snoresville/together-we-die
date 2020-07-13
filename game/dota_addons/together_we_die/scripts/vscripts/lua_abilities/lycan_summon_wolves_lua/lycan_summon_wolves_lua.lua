lycan_summon_wolves_lua = class({})
LinkLuaModifier("modifier_lycan_summon_wolves_lua", "lua_abilities/lycan_summon_wolves_lua/modifier_lycan_summon_wolves_lua", LUA_MODIFIER_MOTION_NONE)

-------------------------

function lycan_summon_wolves_lua:KillWolves()
    local targets = self.wolves or {}
    for _, unit in pairs(targets) do
        if unit and IsValidEntity(unit) then
            unit:ForceKill(false)
        end
    end
end

function lycan_summon_wolves_lua:OnSpellStart()

    -- Gets the number of wolves to summon
    local wolfCount = self:GetSpecialValueFor("wolf_count")

    -- Determining the stats of a wolf
    -- From Stats
    local wolfHealthBuff = self:GetCaster():GetStrength() * self:GetSpecialValueFor("wolf_hp_per_str")
    local wolfArmorBuff = self:GetCaster():GetStrength() * self:GetSpecialValueFor("wolf_armor_per_str")
    local wolfDurationBuff = self:GetSpecialValueFor("wolf_duration")

    -- From Stacks
    local wolfDamageBuff = self:GetCaster():GetStrength() * self:GetSpecialValueFor("wolf_dmg_per_str")

    -- Positioning the wolf spawn
    local caster = self:GetCaster()
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    local frontPosition = origin + fv * 200

    -- Creating the Wolves
    self:KillWolves()
    self.wolves = { }

    for i = 1, wolfCount do
        local rotatePos = RotatePosition(origin, QAngle(0, i / wolfCount * 360, 0), frontPosition)
        local hWolf = CreateUnitByName("npc_dota_lycan_wolf1", rotatePos, true, caster, caster:GetPlayerOwner(), self:GetCaster():GetTeamNumber())
        if hWolf ~= nil then
            hWolf:SetControllableByPlayer(caster:GetPlayerID(), false)
            hWolf:SetOwner(caster)

            -- Setting the Stats
            local wolf_max_dmg = self:GetSpecialValueFor("wolf_damage") + wolfDamageBuff
            local wolf_min_dmg = self:GetSpecialValueFor("wolf_damage") + wolfDamageBuff
            local wolf_hp = self:GetSpecialValueFor("wolf_hp") + wolfHealthBuff
            hWolf:SetBaseDamageMax(wolf_max_dmg)
            hWolf:SetBaseDamageMin(wolf_min_dmg)
            hWolf:SetBaseMaxHealth(wolf_hp)
            hWolf:SetPhysicalArmorBaseValue(wolfArmorBuff)
            hWolf:SetBaseAttackTime(self:GetSpecialValueFor("wolf_bat"))

            -- Mastery 'Abilities'
            local masteryAbility = hWolf:AddAbility("lycan_wolf_mastery_lua")
            masteryAbility:SetLevel(self:GetLevel())

            -- Wolf Metadata
            local kv = {
                duration = wolfDurationBuff
            }

            hWolf:SetForwardVector(fv)
            hWolf:AddNewModifier(self:GetCaster(), self, "modifier_lycan_summon_wolves_lua", kv)

            table.insert(self.wolves, hWolf)

        end
    end

    EmitSoundOnLocationWithCaster(origin, "Hero_Lycan.SummonWolves", caster)
end