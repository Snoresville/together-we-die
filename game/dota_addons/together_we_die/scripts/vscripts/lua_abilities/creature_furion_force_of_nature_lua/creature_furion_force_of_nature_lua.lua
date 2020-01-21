creature_furion_force_of_nature_lua = class({})
LinkLuaModifier( "modifier_creature_furion_force_of_nature_lua", "lua_abilities/creature_furion_force_of_nature_lua/modifier_creature_furion_force_of_nature_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_furion_force_of_nature_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

--------------------------------------------------------------------------------

function creature_furion_force_of_nature_lua:IsHiddenWhenStolen()
	return true
end

--------------------------------------------------------------------------------

function creature_furion_force_of_nature_lua:OnSpellStart()
	self.area_of_effect = self:GetSpecialValueFor( "area_of_effedact" )
	self.max_treants = self:GetSpecialValueFor( "max_treants" )
	self.duration = self:GetSpecialValueFor( "duration" )

	local vTargetPosition = self:GetCursorPosition()
	local trees = GridNav:GetAllTreesAroundPoint( vTargetPosition, self.area_of_effect, true )
	local nTreeCount = #trees

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff_base", self:GetCaster():GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, vTargetPosition )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.area_of_effect, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	GridNav:DestroyTreesAroundPoint( vTargetPosition, self.area_of_effect, true )

	if nTreeCount == 0 then
		return
	end

	local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
	)

	local nTreantsToSpawn = math.min( self.max_treants, nTreeCount )
	while nTreantsToSpawn > 0 do
		local hTreant = CreateUnitByName( "npc_dota_creature_treant", vTargetPosition, true, nil, nil, DOTA_TEAM_BADGUYS )
		if hTreant ~= nil then
			local kv = {
				duration = self.duration
			}

			hTreant:AddNewModifier( self:GetCaster(), self, "modifier_creature_furion_force_of_nature_lua", kv )

			for _,enemy in pairs(enemies) do
				hTreant:MoveToTargetToAttack( enemy )
				break
			end
		end

		nTreantsToSpawn = nTreantsToSpawn - 1
	end

	EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.ForceOfNature", self:GetCaster() )
end

--------------------------------------------------------------------------------