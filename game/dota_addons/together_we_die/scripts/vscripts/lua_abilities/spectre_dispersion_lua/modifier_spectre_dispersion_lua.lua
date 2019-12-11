modifier_spectre_dispersion_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_dispersion_lua:IsHidden()
    return true
end

function modifier_spectre_dispersion_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spectre_dispersion_lua:OnCreated(kv)
    -- references
    self.damage_reflection_pct = self:GetAbility():GetSpecialValueFor("damage_reflection_pct")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")

end

function modifier_spectre_dispersion_lua:OnRefresh(kv)
    -- references
    self.damage_reflection_pct = self:GetAbility():GetSpecialValueFor("damage_reflection_pct")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
end

function modifier_spectre_dispersion_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spectre_dispersion_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage(params)
    if not IsServer() or self:GetParent():PassivesDisabled() or self:GetParent():GetTeamNumber() == params.attacker:GetTeamNumber() or self:FlagExist(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then
        return 0
    end

    local parent = self:GetParent()
    local MAX_REDUCTION = 99
    local reduction = math.min(self.damage_reflection_pct + math.floor(parent:GetAgility() * self.agi_multiplier), MAX_REDUCTION)

    -- Reflect all that damage back to everyone in the vicinity
    local damageToDeal = math.floor(params.original_damage * (reduction / 100))
    local damageType = params.damage_type
    local damageTable = {
        attacker = parent,
        damage = damageToDeal,
        damage_type = damageType,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
    }
    -- find enemies
    local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(), -- int, your team number
            parent:GetOrigin(), -- point, center point
            parent, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    -- damage
    for _, enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
    end

    return -reduction
end

function modifier_spectre_dispersion_lua:PlayEffects(target)
    local particle_cast = "particles/units/heroes/hero_spectre/spectre_dispersion.vpcf"

    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            self:GetParent():GetOrigin(), -- unknown
            true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
            effect_cast,
            1,
            target,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            target:GetOrigin(), -- unknown
            true -- unknown, true
    )
end

-- Helper: Flag operations
function modifier_spectre_dispersion_lua:FlagExist(a, b)
    --Bitwise Exist
    local p, c, d = 1, 0, b
    while a > 0 and b > 0 do
        local ra, rb = a % 2, b % 2
        if ra + rb > 1 then
            c = c + p
        end
        a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
    end
    return c == d
end
