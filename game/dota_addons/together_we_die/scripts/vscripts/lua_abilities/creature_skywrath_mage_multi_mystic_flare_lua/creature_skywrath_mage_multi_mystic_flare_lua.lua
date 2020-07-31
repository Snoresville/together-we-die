creature_skywrath_mage_multi_mystic_flare_lua = class({})
LinkLuaModifier("modifier_creature_skywrath_mage_multi_mystic_flare_lua_thinker", "lua_abilities/creature_skywrath_mage_multi_mystic_flare_lua/modifier_creature_skywrath_mage_multi_mystic_flare_lua_thinker", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function creature_skywrath_mage_multi_mystic_flare_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Ability Start
function creature_skywrath_mage_multi_mystic_flare_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local duration = self:GetSpecialValueFor("duration")

    -- create thinker
    CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_creature_skywrath_mage_multi_mystic_flare_lua_thinker", -- modifier name
            { duration = duration }, -- kv
            point,
            caster:GetTeamNumber(),
            false
    )

    local inner = Vector(300, 0, 0)
    local outer = Vector(800, 0, 0)
    for i = 0, 3 do
        local innerLocation = RotatePosition(Vector(0, 0, 0), QAngle(0, 90 * i, 0), inner)

        -- create thinker
        CreateModifierThinker(
                caster, -- player source
                self, -- ability source
                "modifier_creature_skywrath_mage_multi_mystic_flare_lua_thinker", -- modifier name
                { duration = duration }, -- kv
                point + innerLocation,
                caster:GetTeamNumber(),
                false
        )
    end

    for i = 0, 11 do
        local outerLocation = RotatePosition(Vector(0, 0, 0), QAngle(0, 30 * i, 0), outer)
        -- create thinker
        CreateModifierThinker(
                caster, -- player source
                self, -- ability source
                "modifier_creature_skywrath_mage_multi_mystic_flare_lua_thinker", -- modifier name
                { duration = duration }, -- kv
                point + outerLocation,
                caster:GetTeamNumber(),
                false
        )
    end

    -- play effects
    local sound_cast = "Hero_SkywrathMage.MysticFlare.Cast"
    EmitSoundOn(sound_cast, caster)
end