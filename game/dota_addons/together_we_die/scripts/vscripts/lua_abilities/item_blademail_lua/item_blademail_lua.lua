item_blademail_lua = class({})
LinkLuaModifier("modifier_item_blademail_lua", "lua_abilities/item_blademail_lua/modifier_item_blademail_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_blademail_lua_buff", "lua_abilities/item_blademail_lua/modifier_item_blademail_lua_buff", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function item_blademail_lua:GetIntrinsicModifierName()
    return "modifier_item_blademail_lua"
end

-- Ability Start
function item_blademail_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    -- self buff
    caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_item_blademail_lua_buff", -- modifier name
            { duration = duration } -- kv
    )
end