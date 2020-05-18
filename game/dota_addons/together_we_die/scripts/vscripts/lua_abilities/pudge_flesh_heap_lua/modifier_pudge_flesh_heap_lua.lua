modifier_pudge_flesh_heap_lua = class({})

--------------------------------------------------------------------------------
function modifier_pudge_flesh_heap_lua:IsHidden()
    return false
end

function modifier_pudge_flesh_heap_lua:IsDebuff()
    return false
end

function modifier_pudge_flesh_heap_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_lua:OnCreated(kv)
    self.flesh_heap_regen_bonus = self:GetAbility():GetSpecialValueFor("flesh_heap_regen_bonus")
    self.flesh_heap_strength_buff_amount = self:GetAbility():GetSpecialValueFor("flesh_heap_strength_buff_amount")
    if IsServer() then
        self:SetStackCount(self:GetAbility():GetFleshHeapKills())
        self:GetParent():CalculateStatBonus()
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_lua:OnRefresh(kv)
    self.flesh_heap_regen_bonus = self:GetAbility():GetSpecialValueFor("flesh_heap_regen_bonus")
    self.flesh_heap_strength_buff_amount = self:GetAbility():GetSpecialValueFor("flesh_heap_strength_buff_amount")
    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_pudge_flesh_heap_lua:OnDeath(event)
    if event.unit == nil or event.attacker == nil or event.unit:IsNull() or event.attacker:IsNull() then
        return
    end

    if self:GetParent():PassivesDisabled() then
        return
    end

    if event.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() and self:GetParent():IsAlive() then
        if event.attacker ~= self:GetParent() then
            if self:GetAbility():IsFullyCastable() then
                -- Check range
                self.flesh_heap_range = self:GetAbility():GetSpecialValueFor("flesh_heap_range")
                local vToParent = self:GetParent():GetOrigin() - event.unit:GetOrigin()
                local flDistance = vToParent:Length2D()
                if flDistance <= self.flesh_heap_range then
                    -- cooldown
                    self:GetAbility():UseResources(false, false, true)
                else
                    -- Not in range, ignore
                    return
                end
            else
                return
            end
        end
        self:GetAbility():IncrementFleshHeapKills()

        self:SetStackCount(self:GetAbility():GetFleshHeapKills())
        self:GetParent():CalculateStatBonus()

        local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1, 0, 0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_lua:GetModifierConstantHealthRegen(params)
    if not self:GetParent():PassivesDisabled() then
        return self:GetStackCount() * self.flesh_heap_regen_bonus
    end
    return 0
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_lua:GetModifierBonusStats_Strength(params)
    return self:GetStackCount() * self.flesh_heap_strength_buff_amount
end


--------------------------------------------------------------------------------