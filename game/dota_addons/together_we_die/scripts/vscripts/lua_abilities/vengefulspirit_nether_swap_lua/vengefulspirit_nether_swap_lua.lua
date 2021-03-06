vengefulspirit_nether_swap_lua = class({})

--------------------------------------------------------------------------------

function vengefulspirit_nether_swap_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function vengefulspirit_nether_swap_lua:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function vengefulspirit_nether_swap_lua:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	if hTarget:IsAncient() then
		return "#dota_hud_error_cant_cast_on_ancient"
	end

	if hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) then
		return "#dota_hud_error_cant_cast_on_creep"
	end

	return ""
end

--------------------------------------------------------------------------------

function vengefulspirit_nether_swap_lua:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "nether_swap_cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function vengefulspirit_nether_swap_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil or hTarget:TriggerSpellAbsorb( this ) then
		return
	end

	local vPos1 = hCaster:GetOrigin()
	local vPos2 = hTarget:GetOrigin()

	local search = self:GetSpecialValueFor( "radius" )
	targets = FindUnitsInRadius(
		hCaster:GetTeamNumber(),	-- int, your team number
		vPos2,	-- point, center point
		hTarget,	-- handle, cacheUnit. (not known)
		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	GridNav:DestroyTreesAroundPoint( vPos1, 300, false )
	GridNav:DestroyTreesAroundPoint( vPos2, 300, false )

	hCaster:SetOrigin( vPos2 )
	for _,enemy in pairs(targets) do
		enemy:SetOrigin( vPos1 )
		FindClearSpaceForUnit( enemy, vPos1, true )
		enemy:Interrupt()

		local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
		ParticleManager:SetParticleControlEnt( nCasterFX, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), false )
		ParticleManager:ReleaseParticleIndex( nCasterFX )
	end

	FindClearSpaceForUnit( hCaster, vPos2, true )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )

	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
