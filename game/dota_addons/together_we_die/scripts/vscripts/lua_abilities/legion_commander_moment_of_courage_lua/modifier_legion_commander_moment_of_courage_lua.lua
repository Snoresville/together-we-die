modifier_legion_commander_moment_of_courage_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_legion_commander_moment_of_courage_lua:IsHidden()
    return true
end

function modifier_legion_commander_moment_of_courage_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_legion_commander_moment_of_courage_lua:OnCreated(kv)
    -- references
    self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration") -- special value
end

function modifier_legion_commander_moment_of_courage_lua:OnRefresh(kv)
    -- references
    self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration") -- special value
end

function modifier_legion_commander_moment_of_courage_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_legion_commander_moment_of_courage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }

    return funcs
end
function modifier_legion_commander_moment_of_courage_lua:OnAttacked(params)
    local abilityParent = self:GetParent()
    if IsServer() then
        -- not proc if it isn't the target
        if params.target ~= abilityParent then return end

        -- not proc for when attacked by allies
        if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

        -- not proc if break
        if abilityParent:PassivesDisabled() then return end

        -- not proc if on cooldown
        if not self:GetAbility():IsFullyCastable() then return end

        -- no proc if self attack or reflected attack
        if params.attacker == abilityParent or self:FlagExist(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then
            return
        end

        local moment_of_courage_modifier = "modifier_legion_commander_moment_of_courage_lua_buff"
        local buff_modifier = abilityParent:FindModifierByName(moment_of_courage_modifier)
        if buff_modifier then
            buff_modifier:IncrementStackCount()
            buff_modifier:ForceRefresh()
        else
            abilityParent:AddNewModifier(
                    abilityParent,
                    self:GetAbility(),
                    moment_of_courage_modifier,
                    {
                        duration = self.buff_duration,
                    }
            )
        end

        -- cooldown
        self:GetAbility():UseResources( false, false, true )
    end
end

-- Helper: Flag operations
function modifier_legion_commander_moment_of_courage_lua:FlagExist(a, b)
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