modifier_creature_poison_spears_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_poison_spears_lua:IsHidden()
    return true
end

function modifier_creature_poison_spears_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_poison_spears_lua:OnCreated(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration") -- special value
end

function modifier_creature_poison_spears_lua:OnRefresh(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration") -- special value
end

function modifier_creature_poison_spears_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_poison_spears_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_creature_poison_spears_lua:OnAttackLanded(params)
    if IsServer() then
        if params.attacker ~= self:GetParent() then
            return
        end

        -- cancel if immune
        if params.target:IsMagicImmune() then
            return
        end

        -- cancel if break
        if self:GetParent():PassivesDisabled() then
            return
        end

        -- add modifier
        params.target:AddNewModifier(
                self:GetParent(), -- player source
                self:GetAbility(), -- ability source
                "modifier_creature_poison_spears_lua_debuff", -- modifier name
                {
                    duration = self.duration
                } -- kv
        )
    end
end