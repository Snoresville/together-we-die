modifier_creature_slark_essence_shift_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_slark_essence_shift_lua:IsHidden()
    return true
end

function modifier_creature_slark_essence_shift_lua:IsDebuff()
    return false
end

function modifier_creature_slark_essence_shift_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_slark_essence_shift_lua:OnCreated(kv)
    -- references
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.agi_debuff_modifier_name = "modifier_creature_slark_essence_shift_lua_debuff"
    self.agi_stack_modifier_name = "modifier_creature_slark_essence_shift_lua_stack"
end

function modifier_creature_slark_essence_shift_lua:OnRefresh(kv)
    -- references
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_creature_slark_essence_shift_lua:OnDestroy(kv)
end

function modifier_creature_slark_essence_shift_lua:OnRemoved()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_slark_essence_shift_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }

    return funcs
end

function modifier_creature_slark_essence_shift_lua:GetModifierProcAttack_Feedback(params)
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        -- filter enemy
        local target = params.target
        -- Make sure attacker isn't a building
        if target:IsBuilding() then
            return
        end

        -- Apply debuff to enemy
        local debuff_modifier = params.target:FindModifierByName(self.agi_debuff_modifier_name)
        if debuff_modifier then
            debuff_modifier:IncrementStackCount()
            debuff_modifier:ForceRefresh()
        else
            params.target:AddNewModifier(
                    self:GetParent(),
                    self:GetAbility(),
                    self.agi_debuff_modifier_name,
                    {
                        duration = self.duration,
                    }
            )
        end

        -- Apply buff to self
        local buff_modifier = self:GetParent():FindModifierByName(self.agi_stack_modifier_name)
        if buff_modifier then
            buff_modifier:IncrementStackCount()
            buff_modifier:ForceRefresh()
        else
            self:GetParent():AddNewModifier(
                    self:GetParent(),
                    self:GetAbility(),
                    self.agi_stack_modifier_name,
                    {
                        duration = self.duration,
                    }
            )
        end

        -- Play effects
        self:PlayEffects(params.target)
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_slark_essence_shift_lua:PlayEffects(target)
    local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect_cast, 1, self:GetParent():GetOrigin() + Vector(0, 0, 64))
    ParticleManager:ReleaseParticleIndex(effect_cast)
end