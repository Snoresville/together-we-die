--------------------------------------------------------------------------------
riki_smoke_screen_lua = class({})
LinkLuaModifier("modifier_riki_smoke_screen_lua", "lua_abilities/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_debuff", "lua_abilities/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_debuff", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function riki_smoke_screen_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Ability Start
function riki_smoke_screen_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local duration = self:GetSpecialValueFor("duration")

    -- create thinker
    CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_riki_smoke_screen_lua", -- modifier name
            { duration = duration }, -- kv
            point,
            caster:GetTeamNumber(),
            false
    )
end