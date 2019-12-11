modifier_arc_warden_flux_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_warden_flux_lua:IsHidden()
    return false
end

function modifier_arc_warden_flux_lua:IsDebuff()
    return true
end

function modifier_arc_warden_flux_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_arc_warden_flux_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    -- references
    self.move_speed_slow_pct = self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
    self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
    self.think_interval = self:GetAbility():GetSpecialValueFor("think_interval")
    self.friendly_nearby = false
    local damage_per_second = self:GetAbility():GetSpecialValueFor("damage_per_second")
    local agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    local caster = self:GetCaster()
    local damage = (damage_per_second + agi_multiplier * caster:GetAgility()) * self.think_interval
    self.damageTable = {
        victim = self:GetParent(),
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(), --Optional.
    }

    -- Play Effects
    self:PlayEffects()

    self:OnIntervalThink()
    self:StartIntervalThink(self.think_interval)
end

function modifier_arc_warden_flux_lua:OnRefresh(kv)
    self:OnCreated(kv)
end

function modifier_arc_warden_flux_lua:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_arc_warden_flux_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

if IsServer() then
    function modifier_arc_warden_flux_lua:GetModifierMoveSpeedBonus_Percentage()
        if not self.friendly_nearby then
            return -self.move_speed_slow_pct
        end
        return 0
    end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_arc_warden_flux_lua:OnIntervalThink()
    local parent = self:GetParent()
    -- find friendly units near targeted unit
    local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(), -- int, your team number
            parent:GetOrigin(), -- point, center point
            parent, -- handle, cacheUnit. (not known)
            self.search_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    if #enemies ~= 0 then
        for _, enemy in pairs(enemies) do
            -- Check if enemy also have this debuff
            if not enemy:HasModifier("modifier_arc_warden_flux_lua") then
                -- Enemy does not have debuff, do not deal damage
                self.friendly_nearby = true
                return
            end
        end
    end

    -- No friendly without debuff nearby
    self.friendly_nearby = false
    -- Deal damage
    ApplyDamage(self.damageTable)
end

function modifier_arc_warden_flux_lua:PlayEffects()
    -- effects
    local sound_cast = "Hero_ArcWarden.Flux.Target"
    EmitSoundOn(sound_cast, self:GetParent())
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_arc_warden_flux_lua:GetEffectName()
    return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end

function modifier_arc_warden_flux_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end