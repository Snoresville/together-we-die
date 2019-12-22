ursa_enrage_lua = class({})
LinkLuaModifier("modifier_ursa_enrage_lua", "lua_abilities/ursa_enrage_lua/modifier_ursa_enrage_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function ursa_enrage_lua:GetBehavior()
    local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
    if self:GetCaster():HasScepter() then
        behavior = behavior + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    end
    return behavior
end

function ursa_enrage_lua:GetCooldown(level)
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown(self, level)
end

function ursa_enrage_lua:OnSpellStart()
    -- get references
    local caster = self:GetCaster()
    local bonus_duration = self:GetSpecialValueFor("duration")

    -- Purge
    caster:Purge(false, true, false, true, false)

    -- Add buff modifier
    caster:AddNewModifier(
            caster,
            self,
            "modifier_ursa_enrage_lua",
            { duration = bonus_duration }
    )

    -- STRONG dispel target (good dispel & remove stun)
    caster:Purge(false, true, false, true, true)

    -- play effects
    self:PlayEffects()
end

function ursa_enrage_lua:PlayEffects()
    -- get resources
    local sound_cast = "Hero_Ursa.Enrage"

    -- play sound
    EmitSoundOn(sound_cast, self:GetCaster())
end