modifier_techies_land_mines_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_techies_land_mines_lua:IsHidden()
    return true
end

function modifier_techies_land_mines_lua:IsDebuff()
    return false
end

function modifier_techies_land_mines_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_techies_land_mines_lua:OnCreated(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.activation_delay = self:GetAbility():GetSpecialValueFor("activation_delay")
    self.activated = false

    local interval = 0.1

    if IsServer() then
        -- precache damage
        self.damageTable = {
            -- victim
            attacker = self:GetCaster(),
            -- damage
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }

        -- start interval
        self:StartIntervalThink(interval)
    end
end

function modifier_techies_land_mines_lua:OnRefresh(kv)

end

function modifier_techies_land_mines_lua:OnDestroy(kv)
    if not IsServer() then
        return
    end
    -- blow up
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            self:GetParent():GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
            self:GetAbility():GetAbilityTargetType(), -- int, type filter
            self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    local damage = self:GetAbility():GetSpecialValueFor("damage")
    local int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier")
    self.damageTable.damage = damage + self:GetCaster():GetIntellect() * int_multiplier

    for _, enemy in pairs(enemies) do
        self.damageTable.victim = enemy
        ApplyDamage(self.damageTable)
    end
    -- play explosion effects
    self:PlayEffects()
    -- Remove mines table
    self:GetAbility():RemoveMine(self:GetParent())
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_techies_land_mines_lua:OnIntervalThink()
    if self.activated then
        -- Blow it up
        self:GetParent():ForceKill(false)
    end

    -- Search for enemies
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            self:GetParent():GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            self.radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbility():GetAbilityTargetTeam(), -- int, team filter
            self:GetAbility():GetAbilityTargetType(), -- int, type filter
            self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )

    if #enemies ~= 0 then
        self.activated = true
        self:StartIntervalThink(self.activation_delay)
    end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_techies_land_mines_lua:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
    }

    return state
end

function modifier_techies_land_mines_lua:GetModifierInvisibilityLevel()
    return 1
end

--------------------------------------------------------------------------------
-- Effects
function modifier_techies_land_mines_lua:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
    local sound_cast = "Hero_Techies.LandMine.Detonate"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(0, 0, self.radius))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetParent())
end