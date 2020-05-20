modifier_lion_finger_of_death_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lion_finger_of_death_lua:IsHidden()
    return true
end

function modifier_lion_finger_of_death_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_lion_finger_of_death_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lion_finger_of_death_lua:OnCreated(kv)
    -- references
    local stack_count = self:GetCaster():GetModifierStackCount("modifier_lion_finger_of_death_lua_stack", self:GetCaster()) or 0
    local total_int_multiplier = self:GetAbility():GetSpecialValueFor("int_multiplier") + self:GetAbility():GetSpecialValueFor("int_multiplier_per_stack") * stack_count
    if self:GetCaster():HasScepter() then
        self.damage = self:GetAbility():GetSpecialValueFor("damage_scepter") + self:GetCaster():GetIntellect() * total_int_multiplier -- special value
    else
        self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetIntellect() * total_int_multiplier -- special value
    end
end

function modifier_lion_finger_of_death_lua:OnDestroy(kv)
    if IsServer() then
        -- check if it's still valid target
        if not self:GetParent():IsAlive() then
            return
        end
        local nResult = UnitFilter(
                self:GetParent(),
                self:GetAbility():GetAbilityTargetTeam(),
                self:GetAbility():GetAbilityTargetType(),
                0,
                self:GetCaster():GetTeamNumber()
        )
        if nResult ~= UF_SUCCESS then
            return
        end

        -- damage
        local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }
        ApplyDamage(damageTable)

        if not self:GetParent():IsAlive() then
            -- add stack modifier
            self:GetCaster():AddNewModifier(
                    self:GetCaster(), -- player source
                    self:GetAbility(), -- ability source
                    "modifier_lion_finger_of_death_lua_stack", -- modifier name
                    {}
            )
        end
    end
end