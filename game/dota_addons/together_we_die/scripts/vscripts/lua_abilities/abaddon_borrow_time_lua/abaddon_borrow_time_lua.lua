abaddon_borrow_time_lua = class({})
LinkLuaModifier("modifier_abaddon_borrow_time_lua", "lua_abilities/abaddon_borrow_time_lua/modifier_abaddon_borrow_time_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abaddon_borrow_time_lua_buff", "lua_abilities/abaddon_borrow_time_lua/modifier_abaddon_borrow_time_lua_buff", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- AOE Radius
function abaddon_borrow_time_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
--------------------------------------------------------------------------------
-- Passive Modifier
function abaddon_borrow_time_lua:GetIntrinsicModifierName()
    return "modifier_abaddon_borrow_time_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function abaddon_borrow_time_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    if self:GetCaster():HasScepter() then
        duration = self:GetSpecialValueFor("duration_scepter")
    end

    -- Find Units in Radius
    local targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            caster:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- Apply buff
    for _, buffTarget in pairs(targets) do
        -- dispel target (STRONG dispel + stun dispel)
        buffTarget:Purge(false, true, false, true, true)
        buffTarget:AddNewModifier(
                caster,
                self,
                "modifier_abaddon_borrow_time_lua_buff",
                {
                    duration = duration
                }
        )
    end

    local sound_cast = "Hero_Abaddon.BorrowedTime"
    EmitSoundOn(sound_cast, self:GetCaster())
end
