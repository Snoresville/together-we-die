--------------------------------------------------------------------------------
modifier_perfect_stance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_perfect_stance_lua:IsHidden()
    return false
end

function modifier_perfect_stance_lua:IsDebuff()
    return false
end

function modifier_perfect_stance_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_perfect_stance_lua:OnCreated(kv)
    -- references
    self.physical_damage_reduction = self:GetAbility():GetSpecialValueFor("physical_damage_reduction")
    self.physical_deflection = self:GetAbility():GetSpecialValueFor("physical_deflection")
end

function modifier_perfect_stance_lua:OnRefresh(kv)
    -- references
    self.physical_damage_reduction = self:GetAbility():GetSpecialValueFor("physical_damage_reduction")
    self.physical_deflection = self:GetAbility():GetSpecialValueFor("physical_deflection")
end

function modifier_perfect_stance_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_perfect_stance_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    }

    return funcs
end

function modifier_perfect_stance_lua:GetModifierPhysical_ConstantBlock(params)
    if not IsServer() then
        return 0
    end

    -- cancel if from ability
    if params.inflictor then
        return 0
    end

    -- cancel if break
    if params.target:PassivesDisabled() then
        return 0
    end

    -- cancel if strength is not the greatest attribute
    if self:GetParent():GetStrength() <= (self:GetParent():GetIntellect() + self:GetParent():GetAgility()) then
        return 0
    end

    -- get data
    local parent = params.target
    local attacker = params.attacker
    local reduction = self.physical_damage_reduction
    local deflection = self.physical_damage_reduction
    local damageToDeal = math.floor(deflection * params.damage / 100)

    -- deflect damage back to enemy
    local damageTable = {
        attacker = parent,
        damage = damageToDeal,
        damage_type = params.damage_type,
        victim = attacker,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
    }
    ApplyDamage(damageTable)

    return math.floor(reduction * params.damage / 100)
end