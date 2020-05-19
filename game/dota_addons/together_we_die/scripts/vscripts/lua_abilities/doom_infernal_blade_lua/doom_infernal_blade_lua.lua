-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
doom_infernal_blade_lua = class({})
LinkLuaModifier("modifier_generic_orb_effect_lua", "lua_abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_break_lua", "lua_abilities/generic/modifier_generic_break_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doom_infernal_blade_lua", "lua_abilities/doom_infernal_blade_lua/modifier_doom_infernal_blade_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Cast Filter
function doom_infernal_blade_lua:CastFilterResultTarget(hTarget)
    if not IsServer() then
        return UF_SUCCESS
    end

    local nResult = UnitFilter(
            hTarget,
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            self:GetAbilityTargetFlags(),
            self:GetCaster():GetTeamNumber()
    )
    if nResult ~= UF_SUCCESS then
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Passive Modifier
function doom_infernal_blade_lua:GetIntrinsicModifierName()
    return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function doom_infernal_blade_lua:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function doom_infernal_blade_lua:OnOrbImpact(params)
    -- get reference
    local duration = self:GetSpecialValueFor("burn_duration")
    local bash = self:GetSpecialValueFor("ministun_duration")
    local break_duration = self:GetSpecialValueFor("break_duration")

    -- add debuff
    params.target:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_doom_infernal_blade_lua", -- modifier name
            { duration = duration } -- kv
    )

    -- add ministun
    params.target:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_stunned_lua", -- modifier name
            { duration = bash } -- kv
    )

    if self:GetCaster():HasScepter() then
        -- add break
        params.target:AddNewModifier(
                self:GetCaster(), -- player source
                self, -- ability source
                "modifier_generic_break_lua", -- modifier name
                { duration = break_duration } -- kv
        )
    end

end