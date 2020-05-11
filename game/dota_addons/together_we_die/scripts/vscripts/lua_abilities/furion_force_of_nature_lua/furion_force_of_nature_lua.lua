furion_force_of_nature_lua = class({})
LinkLuaModifier( "modifier_furion_force_of_nature_lua", "lua_abilities/furion_force_of_nature_lua/modifier_furion_force_of_nature_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:IsHiddenWhenStolen()
	return true
end

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:OnSpellStart()
	self.area_of_effect = self:GetSpecialValueFor( "area_of_effect" )
	self.max_treants = self:GetSpecialValueFor( "max_treants" )
	self.duration = self:GetSpecialValueFor( "duration" )
	self.health_int_multiplier = self:GetSpecialValueFor( "health_int_multiplier" )
	self.damage_int_multiplier = self:GetSpecialValueFor( "damage_int_multiplier" )

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

	local nTreantsToSpawn = math.min( self.max_treants, nTreeCount )
	local treant_hp_buff = self:GetCaster():GetIntellect() * self.health_int_multiplier
	local treant_dmg_buff = self:GetCaster():GetIntellect() * self.damage_int_multiplier
	while nTreantsToSpawn > 0 do
		local abilityLevel = self:GetLevel()
		local hTreant = CreateUnitByName( "npc_dota_furion_holdout_treant_" .. abilityLevel, vTargetPosition, true, self:GetCaster(), self:GetCaster():GetPlayerOwner(), self:GetCaster():GetTeamNumber() )
		if hTreant ~= nil then
			hTreant:SetControllableByPlayer( self:GetCaster():GetPlayerID(), false )
			hTreant:SetOwner( self:GetCaster() )
			local treant_max_dmg = hTreant:GetBaseDamageMax() + treant_dmg_buff
			local treant_min_dmg = hTreant:GetBaseDamageMin() + treant_dmg_buff
			local treant_hp = hTreant:GetBaseMaxHealth() + treant_hp_buff
			hTreant:SetBaseDamageMax( treant_max_dmg )
			hTreant:SetBaseDamageMin( treant_min_dmg )
			hTreant:SetBaseMaxHealth( treant_hp )

			local kv = {
				duration = self.duration
			}

			hTreant:AddNewModifier( self:GetCaster(), self, "modifier_furion_force_of_nature_lua", kv )
		end

		nTreantsToSpawn = nTreantsToSpawn - 1
	end

	EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.ForceOfNature", self:GetCaster() )
end

--------------------------------------------------------------------------------