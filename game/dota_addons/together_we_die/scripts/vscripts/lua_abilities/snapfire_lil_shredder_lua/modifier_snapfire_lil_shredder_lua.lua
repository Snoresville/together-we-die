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
modifier_snapfire_lil_shredder_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_lil_shredder_lua:IsHidden()
    return false
end

function modifier_snapfire_lil_shredder_lua:IsDebuff()
    return false
end

function modifier_snapfire_lil_shredder_lua:IsStunDebuff()
    return false
end

function modifier_snapfire_lil_shredder_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_lil_shredder_lua:OnCreated(kv)
    -- references
    self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("str_multiplier")
    self.as_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
    self.range_bonus = self:GetAbility():GetSpecialValueFor("attack_range_bonus")
    self.bat = self:GetAbility():GetSpecialValueFor("base_attack_time")
    -- Talent Tree
    if self:GetCaster():GetModifierStackCount("modifier_snapfire_lil_shredder_bat_lua", self:GetCaster()) ~= 0 then
        self.bat = self.bat - (self:GetCaster():GetModifierStackCount("modifier_snapfire_lil_shredder_bat_lua", self:GetCaster()) / 10)
    end
    self.slow = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.debuff_modifier_name = "modifier_snapfire_lil_shredder_lua_debuff"

    if not IsServer() then
        return
    end
    self.attacks = self:GetAbility():GetSpecialValueFor("buffed_attacks")
    -- Talent Tree
    local special_lil_shredder_buffed_attacks_lua = self:GetCaster():FindAbilityByName("special_lil_shredder_buffed_attacks_lua")
    if special_lil_shredder_buffed_attacks_lua and special_lil_shredder_buffed_attacks_lua:GetLevel() ~= 0 then
        self.attacks = self.attacks + special_lil_shredder_buffed_attacks_lua:GetSpecialValueFor("value")
    end
    self:SetStackCount(self:GetStackCount() + self.attacks)

    self.records = {}

    -- play Effects & Sound
    self:PlayEffects()
    local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
    EmitSoundOn(sound_cast, self:GetParent())
end

function modifier_snapfire_lil_shredder_lua:OnRefresh(kv)
    self:OnCreated(kv)
end

function modifier_snapfire_lil_shredder_lua:OnRemoved()
end

function modifier_snapfire_lil_shredder_lua:OnDestroy()
    if not IsServer() then
        return
    end

    -- stop sound
    local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
    StopSoundOn(sound_cast, self:GetParent())
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_snapfire_lil_shredder_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    }

    return funcs
end

function modifier_snapfire_lil_shredder_lua:OnAttack(params)
    if params.attacker ~= self:GetParent() then
        return
    end
    if self:GetStackCount() <= 0 then
        return
    end

    -- record attack
    self.records[params.record] = true

    -- play sound
    local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
    EmitSoundOn(sound_cast, self:GetParent())

    -- decrement stack
    if self:GetStackCount() > 0 then
        self:DecrementStackCount()
    end
end

function modifier_snapfire_lil_shredder_lua:OnAttackLanded(params)
    if self.records[params.record] then
        -- Apply debuff to enemy
        local debuff_modifier = params.target:FindModifierByName(self.debuff_modifier_name)
        if debuff_modifier then
            debuff_modifier:IncrementStackCount()
            debuff_modifier:ForceRefresh()
        else
            params.target:AddNewModifier(
                    self:GetParent(),
                    self:GetAbility(),
                    self.debuff_modifier_name,
                    {
                        duration = self.slow,
                    }
            )
        end
    end

    -- play sound
    local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Target"
    EmitSoundOn(sound_cast, params.target)
end

function modifier_snapfire_lil_shredder_lua:OnAttackRecordDestroy(params)
    if self.records[params.record] then
        self.records[params.record] = nil

        -- if table is empty and no stack left, destroy
        if next(self.records) == nil and self:GetStackCount() <= 0 then
            self:Destroy()
        end
    end
end

function modifier_snapfire_lil_shredder_lua:GetModifierProjectileName()
    if self:GetStackCount() <= 0 then
        return
    end
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_snapfire_lil_shredder_lua:GetModifierOverrideAttackDamage()
    if self:GetStackCount() <= 0 then
        return
    end
    return self.damage
end

function modifier_snapfire_lil_shredder_lua:GetModifierAttackRangeBonus()
    if self:GetStackCount() <= 0 then
        return
    end
    return self.range_bonus
end

function modifier_snapfire_lil_shredder_lua:GetModifierAttackSpeedBonus_Constant()
    if self:GetStackCount() <= 0 then
        return
    end
    return self.as_bonus
end

function modifier_snapfire_lil_shredder_lua:GetModifierBaseAttackTimeConstant()
    if self:GetStackCount() <= 0 then
        return
    end
    return self.bat
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_snapfire_lil_shredder_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            3,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            4,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            5,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0), -- unknown
            true -- unknown, true
    )

    -- buff particle
    self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
    )
end