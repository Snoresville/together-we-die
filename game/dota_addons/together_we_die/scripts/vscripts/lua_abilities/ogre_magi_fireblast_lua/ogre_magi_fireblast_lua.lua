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
ogre_magi_fireblast_lua = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function ogre_magi_fireblast_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
--------------------------------------------------------------------------------
-- Ability Start
function ogre_magi_fireblast_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- cancel if linken
    if target:TriggerSpellAbsorb(self) then
        return
    end

    -- load data
    local duration = self:GetSpecialValueFor("stun_duration")
    local int_multiplier = self:GetSpecialValueFor("int_multiplier")
    -- Talent Tree
    local special_fireblast_int_multiplier_lua = self:GetCaster():FindAbilityByName("special_fireblast_int_multiplier_lua")
    if special_fireblast_int_multiplier_lua and special_fireblast_int_multiplier_lua:GetLevel() ~= 0 then
        int_multiplier = int_multiplier + special_fireblast_int_multiplier_lua:GetSpecialValueFor("value")
    end
    local damage = self:GetSpecialValueFor("fireblast_damage") + (self:GetCaster():GetIntellect() * int_multiplier)
    local radius = self:GetSpecialValueFor("radius")
    -- Talent Tree
    local special_fireblast_radius_lua = self:GetCaster():FindAbilityByName("special_fireblast_radius_lua")
    if special_fireblast_radius_lua and special_fireblast_radius_lua:GetLevel() ~= 0 then
        radius = radius + special_fireblast_radius_lua:GetSpecialValueFor("value")
    end

    -- find enemies
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            target:GetOrigin(), -- point, center point
            target, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- Apply damage
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    for _, enemy in pairs(enemies) do
        if not enemy:TriggerSpellAbsorb(self) then
            damageTable.victim = enemy
            ApplyDamage(damageTable)

            -- stun
            enemy:AddNewModifier(
                    self:GetCaster(),
                    self,
                    "modifier_generic_stunned_lua",
                    { duration = duration }
            )

            -- play effects
            self:PlayEffects(enemy)
        end
    end

end

--------------------------------------------------------------------------------
function ogre_magi_fireblast_lua:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf"
    local sound_cast = "Hero_OgreMagi.Fireblast.Cast"
    local sound_target = "Hero_OgreMagi.Fireblast.Target"

    -- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            target,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )
    ParticleManager:SetParticleControl(effect_cast, 1, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetCaster())
    EmitSoundOn(sound_target, target)
end