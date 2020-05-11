furion_sprout_lua = class({})
LinkLuaModifier("modifier_furion_sprout_lua", "lua_abilities/furion_sprout_lua/modifier_furion_sprout_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function furion_sprout_lua:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    self.radius = self:GetSpecialValueFor("radius")
    self.vision_range = self:GetSpecialValueFor("vision_range")
    self.root_radius = self:GetSpecialValueFor("root_radius")

    local hTarget = self:GetCursorTarget()
    if hTarget == nil or (hTarget ~= nil and (not hTarget:TriggerSpellAbsorb(self))) then
        local vTargetPosition
        if hTarget ~= nil then
            vTargetPosition = hTarget:GetOrigin()
        else
            vTargetPosition = self:GetCursorPosition()
        end

        local r = self.radius
        local c = math.sqrt(2) * 0.5 * r
        local x_offset = { -r, -c, 0.0, c, r, c, 0.0, -c }
        local y_offset = { 0.0, c, r, c, 0.0, -c, -r, -c }

        local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(nFXIndex, 0, vTargetPosition)
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(0.0, r, 0.0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        for i = 1, 8 do
            CreateTempTree(vTargetPosition + Vector(x_offset[i], y_offset[i], 0.0), self.duration)
        end

        for i = 1, 8 do
            ResolveNPCPositions(vTargetPosition + Vector(x_offset[i], y_offset[i], 0.0), 64.0) --Tree Radius
        end

        AddFOWViewer(self:GetCaster():GetTeamNumber(), vTargetPosition, self.vision_range, self.duration, false)
        EmitSoundOnLocationWithCaster(vTargetPosition, "Hero_Furion.Sprout", self:GetCaster())

        -- Find Units in Radius and apply root
        local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(), -- int, your team number
                vTargetPosition, -- point, center point
                nil, -- handle, cacheUnit. (not known)
                self.root_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
                self:GetAbilityTargetType(), -- int, type filter
                self:GetAbilityTargetFlags(), -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )

        for _, enemy in pairs(enemies) do
            -- Add modifier
            enemy:AddNewModifier(
                    self:GetCaster(), -- player source
                    self, -- ability source
                    "modifier_furion_sprout_lua", -- modifier name
                    { duration = self.duration } -- kv
            )
        end
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------