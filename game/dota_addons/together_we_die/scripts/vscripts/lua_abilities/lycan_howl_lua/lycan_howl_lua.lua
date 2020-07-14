lycan_howl_lua = class({})
LinkLuaModifier("modifier_lycan_howl_lua", "lua_abilities/lycan_howl_lua/modifier_lycan_howl_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function lycan_howl_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local howl_duration = self:GetSpecialValueFor("howl_duration") + caster:GetStrength() * self:GetSpecialValueFor("howl_duration_increase_per_strength")

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            caster:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    for _, enemy in pairs(enemies) do
        local modifier = enemy:FindModifierByNameAndCaster("modifier_lycan_howl_lua", caster)
        if modifier ~= nil then
            modifier:ForceRefresh()
        else
            enemy:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_lycan_howl_lua", -- modifier name
                    { duration = howl_duration } -- kv
            )
        end
    end

    -- Effects
    self:PlayHowlEffect()
end

--------------------------------------------------------------------------------
-- Effects
function lycan_howl_lua:PlayHowlEffect()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
    local sound_cast = "Hero_Lycan.Howl"

    -- Create Particle )
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetCaster())
end