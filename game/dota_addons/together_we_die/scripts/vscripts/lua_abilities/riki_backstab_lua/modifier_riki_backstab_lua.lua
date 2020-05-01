modifier_riki_backstab_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_backstab_lua:IsHidden()
    return true
end

function modifier_riki_backstab_lua:IsDebuff()
    return false
end

function modifier_riki_backstab_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_backstab_lua:OnCreated(kv)
    -- references
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.angle_back = self:GetAbility():GetSpecialValueFor("back_angle")

    if IsServer() then
        self.damageTable = {
            attacker = self:GetParent(),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }
    end
end

function modifier_riki_backstab_lua:OnRefresh(kv)
    -- references
    self.agi_multiplier = self:GetAbility():GetSpecialValueFor("agi_multiplier")
    self.angle_back = self:GetAbility():GetSpecialValueFor("back_angle")
end

function modifier_riki_backstab_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_riki_backstab_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }

    return funcs
end

function modifier_riki_backstab_lua:OnAttacked(params)
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        local parent = self:GetParent()
        local target = params.target

        if params.attacker ~= parent then
            return
        end

        -- Check target position
        local facing_direction = target:GetAnglesAsVector().y
        local attacker_vector = (parent:GetOrigin() - target:GetOrigin()):Normalized()
        local attacker_direction = VectorToAngles(attacker_vector).y
        local angle_diff = AngleDiff(facing_direction, attacker_direction)
        angle_diff = math.abs(angle_diff)

        -- calculate damage reduction
        if angle_diff > (180 - self.angle_back) then
            -- back damage
            self.damageTable.victim = target
            self.damageTable.damage = self.agi_multiplier * parent:GetAgility()
            ApplyDamage(self.damageTable)
            self:PlayEffects(target)
        end
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_riki_backstab_lua:PlayEffects(target)
    local particle_cast = "particles/units/heroes/hero_riki/riki_backstab.vpcf"

    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end
