lycan_shapeshift_lua = class({})
LinkLuaModifier("modifier_lycan_shapeshift_lua", "lua_abilities/lycan_shapeshift_lua/modifier_lycan_shapeshift_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_lua_speed_aura", "lua_abilities/lycan_shapeshift_lua/modifier_lycan_shapeshift_lua_speed_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_lua_transform", "lua_abilities/lycan_shapeshift_lua/modifier_lycan_shapeshift_lua_transform", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Start Spell
function lycan_shapeshift_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local transformation_time = self:GetSpecialValueFor("transformation_time")
    -- Transformation Script
    caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_lycan_shapeshift_lua_transform", -- modifier name
            { duration = transformation_time } -- kv
    )

    self:PlayEffects()
end

-- Effects
function lycan_shapeshift_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf"
    local sound_cast = "Hero_Lycan.Shapeshift.Cast"

    -- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetCaster())
end