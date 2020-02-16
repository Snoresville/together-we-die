abaddon_aphotic_shield_lua = class({})
LinkLuaModifier("modifier_abaddon_aphotic_shield_lua", "lua_abilities/abaddon_aphotic_shield_lua/modifier_abaddon_aphotic_shield_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- AOE Radius
function abaddon_aphotic_shield_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Ability Start
function abaddon_aphotic_shield_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

    -- Find Units in Radius
    local targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- Apply buff
    for _, buffTarget in pairs(targets) do
        -- dispel target (STRONG dispel + stun dispel)
        buffTarget:Purge( false, true, false, true, true )
        buffTarget:AddNewModifier(
                caster,
                self,
                "modifier_abaddon_aphotic_shield_lua",
                {
                    duration = duration
                }
        )
    end

    local sound_cast = "Hero_Abaddon.AphoticShield.Cast"
    EmitSoundOn( sound_cast, self:GetCaster() )
end
