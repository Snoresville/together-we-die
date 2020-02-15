modifier_item_blademail_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_blademail_lua_buff:IsHidden()
    return false
end

function modifier_item_blademail_lua_buff:IsDebuff()
    return true
end

function modifier_item_blademail_lua_buff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_blademail_lua_buff:OnCreated(kv)
    -- references
    self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
end

function modifier_item_blademail_lua_buff:OnRefresh(kv)
    -- references
    self.primary_attr_multiplier = self:GetAbility():GetSpecialValueFor( "primary_attr_multiplier" )
end

function modifier_item_blademail_lua_buff:OnDestroy(kv)

end

function modifier_item_blademail_lua_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_blademail_lua_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_item_blademail_lua_buff:GetModifierIncomingDamage_Percentage(params)
    if IsServer() then
        if self:FlagExist(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then return end

        local caster = self:GetCaster()
        local bmAttacker = params.attacker
        local reduction = 0 -- no reduction
        local damageType = params.damage_type
        local totalDamage = math.floor(params.original_damage + caster:GetPrimaryStatValue() * self.primary_attr_multiplier)

        if self:GetCaster():IsAlive() then
            local damage = {
                victim = bmAttacker,
                attacker = caster,
                damage = totalDamage,
                damage_type = damageType,
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
                ability = self:GetAbility()
            }

            ApplyDamage( damage )
        end

		return reduction
    end
end

-- Helper: Flag operations
function modifier_item_blademail_lua_buff:FlagExist(a, b)
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
