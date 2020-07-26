modifier_roshan_defense_shell_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_roshan_defense_shell_lua:IsHidden()
    return self:GetParent():GetHealthPercent() > self.hp_percent
end

function modifier_roshan_defense_shell_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_roshan_defense_shell_lua:OnCreated(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
    self.break_damage_reduction = self:GetAbility():GetSpecialValueFor("break_damage_reduction")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
    self.effects_played = false

end

function modifier_roshan_defense_shell_lua:OnRefresh(kv)
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
    self.break_damage_reduction = self:GetAbility():GetSpecialValueFor("break_damage_reduction")
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
end

function modifier_roshan_defense_shell_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_roshan_defense_shell_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_roshan_defense_shell_lua:GetModifierIncomingDamage_Percentage(params)
    if not IsServer() or self:GetParent():GetTeamNumber() == params.attacker:GetTeamNumber() then
        return 0
    end

    local parent = self:GetParent()
    local attacker = params.attacker

    -- Do not activate if health is not lower than percent
    if parent:GetHealthPercent() > self.hp_percent then
        return 0
    end

    -- Add shell effect
    if not self.effects_played then
        self:PlayEffects()
        self.effects_played = true
    end

    -- check position
    local parent_origin = parent:GetAbsOrigin()
    local attacker_origin = attacker:GetAbsOrigin()
    local origin = Vector(parent_origin.x, parent_origin.y, 0)
    local location = Vector(attacker_origin.x, attacker_origin.y, 0)
    local length = (location - origin):Length2D()

    local outside_range = (length > self.radius)
    if outside_range then
        if parent:PassivesDisabled() then
            return self.break_damage_reduction
        else
            return self.damage_reduction
        end
    end

    -- Within range, full damage taken
    return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_roshan_defense_shell_lua:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_degen_aura.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

    -- buff particle
    self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
    )
end