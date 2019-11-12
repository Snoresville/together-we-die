pudge_dismember_lua = class({})
LinkLuaModifier( "modifier_pudge_dismember_lua", "lua_abilities/pudge_dismember_lua/modifier_pudge_dismember_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function pudge_dismember_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
--------------------------------------------------------------------------------

function pudge_dismember_lua:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local point = target:GetOrigin()
		local search = self:GetSpecialValueFor( "radius" )
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			target,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		self.dismember_units = {}
		for _,enemy in pairs(targets) do
			-- cancel if linken
			if not enemy:TriggerSpellAbsorb( self ) then
				table.insert(self.dismember_units, enemy)
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:OnSpellStart()
	if self.dismember_units == nil or #self.dismember_units == 0 then
		self.dismember_units = {}
		self:GetCaster():Interrupt()
		return
	end

	for _,enemy in pairs(self.dismember_units) do
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_pudge_dismember_lua", { duration = self:GetChannelTime() } )
		enemy:Interrupt()
	end
end


--------------------------------------------------------------------------------

function pudge_dismember_lua:OnChannelFinish( bInterrupted )
	if self.dismember_units ~= nil and #self.dismember_units ~= 0 then
		for _,enemy in pairs(self.dismember_units) do
			enemy:RemoveModifierByName( "modifier_pudge_dismember_lua" )
		end
	end
end

--------------------------------------------------------------------------------