lion_hex_lua = class({})
LinkLuaModifier("modifier_lion_hex_lua", "lua_abilities/lion_hex_lua/modifier_lion_hex_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- AOE Radius
function lion_hex_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
-- Ability Start
function lion_hex_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local duration = self:GetSpecialValueFor("duration")

    local search = self:GetSpecialValueFor("radius")
    local targets = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            point, -- point, center point
            nil, -- handle, cacheUnit. (not known)
            search, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    for _, enemy in pairs(targets) do
        -- cancel if linken
        if not enemy:TriggerSpellAbsorb(self) then
            -- add modifier
            enemy:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_lion_hex_lua", -- modifier name
                    { duration = duration } -- kv
            )
        end
    end

    -- effects
    local sound_cast = "Hero_Lion.Voodoo"
    EmitSoundOn(sound_cast, caster)
end