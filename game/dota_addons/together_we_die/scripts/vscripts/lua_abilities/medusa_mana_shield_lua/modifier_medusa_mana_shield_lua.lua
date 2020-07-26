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
modifier_medusa_mana_shield_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mana_shield_lua:IsHidden()
    return false
end

function modifier_medusa_mana_shield_lua:IsDebuff()
    return false
end

function modifier_medusa_mana_shield_lua:IsPurgable()
    return false
end

function modifier_medusa_mana_shield_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_medusa_mana_shield_lua:OnCreated(kv)
    -- references
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.hp_regen_agi_multiplier = self:GetAbility():GetSpecialValueFor("hp_regen_agi_multiplier")
    self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
    self.absorb_pct = self:GetAbility():GetSpecialValueFor("absorption_tooltip") / 100
    self.force_cooldown_duration = self:GetAbility():GetSpecialValueFor("force_cooldown_duration")

    if not IsServer() then
        return
    end
    -- Play effects
    local sound_cast = "Hero_Medusa.ManaShield.On"
    EmitSoundOn(sound_cast, self:GetParent())
end

function modifier_medusa_mana_shield_lua:OnRefresh(kv)
    -- references
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.hp_regen_agi_multiplier = self:GetAbility():GetSpecialValueFor("hp_regen_agi_multiplier")
    self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
    self.absorb_pct = self:GetAbility():GetSpecialValueFor("absorption_tooltip") / 100
    self.force_cooldown_duration = self:GetAbility():GetSpecialValueFor("force_cooldown_duration")
end

function modifier_medusa_mana_shield_lua:OnRemoved()
end

function modifier_medusa_mana_shield_lua:OnDestroy()
    if not IsServer() then
        return
    end
    -- Play effects
    local sound_cast = "Hero_Medusa.ManaShield.Off"
    EmitSoundOn(sound_cast, self:GetParent())
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_medusa_mana_shield_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_medusa_mana_shield_lua:GetModifierIncomingDamage_Percentage(params)
    local absorb = -100 * self.absorb_pct

    -- calculate mana spent
    local damage_absorbed = params.damage * self.absorb_pct
    local manacost = damage_absorbed / (self.damage_per_mana + math.floor(self:GetParent():GetAgility() * self.agi_multiplier))
    local mana = self:GetParent():GetMana()

    -- if not enough mana, calculate damage blocked by remaining mana
    if mana < manacost then
        damage_absorbed = mana * self.damage_per_mana
        absorb = -damage_absorbed / params.damage * 100

        manacost = mana

        -- turn off
        if self:GetAbility():GetToggleState() then
            self:GetAbility():ToggleAbility()
            -- Force cooldown
            self:GetAbility():StartCooldown(self.force_cooldown_duration)
        end
    end

    -- spend mana
    self:GetParent():SpendMana(manacost, self:GetAbility())

    -- play effects
    self:PlayEffects(damage_absorbed)

    return absorb
end

function modifier_medusa_mana_shield_lua:GetModifierConstantHealthRegen()
    if self:GetParent():GetModifierStackCount("modifier_medusa_mana_shield_hp_regen_lua", self:GetParent()) == 1 then
        return self:GetParent():GetAgility() * self.hp_regen_agi_multiplier
    end

    return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_medusa_mana_shield_lua:GetEffectName()
    return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_medusa_mana_shield_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_medusa_mana_shield_lua:PlayEffects(damage)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
    local sound_cast = "Hero_Medusa.ManaShield.Proc"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(damage, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetParent())
end