modifier_boss_morphling_block_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_boss_morphling_block_lua:IsHidden()
	return true
end

function modifier_boss_morphling_block_lua:IsDebuff()
	return false
end

function modifier_boss_morphling_block_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_boss_morphling_block_lua:OnCreated( kv )
	self.interval = self:GetAbility():GetSpecialValueFor( "morph_interval" )

	-- start with strength only
	self.block_type = 0

	-- Start interval
	self:OnIntervalThink()
	self:StartIntervalThink( self.interval )
end

function modifier_boss_morphling_block_lua:OnRefresh( kv )
	self.interval = self:GetAbility():GetSpecialValueFor( "morph_interval" )
end

function modifier_boss_morphling_block_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- OnThink
function modifier_boss_morphling_block_lua:OnIntervalThink()
	if IsServer() then
		local morphling = self:GetParent()

		if self.block_type == 0 then
			-- blocks everything except strength damage
			morphling:AddNewModifier(
				morphling, -- player source
				self:GetAbility(), -- ability source
				"modifier_boss_morphling_block_str_lua", -- modifier name
				{ duration = self.interval }
			)
			
			-- is STR, change to AGI
			self.block_type = 1
		elseif self.block_type == 1 then
			-- blocks everything except agility damage
			morphling:AddNewModifier(
				morphling, -- player source
				self:GetAbility(), -- ability source
				"modifier_boss_morphling_block_agi_lua", -- modifier name
				{ duration = self.interval }
			)

			-- is AGI, change to INT
			self.block_type = 2
		elseif self.block_type == 2 then
			-- blocks everything except intelligence damage
			morphling:AddNewModifier(
				morphling, -- player source
				self:GetAbility(), -- ability source
				"modifier_boss_morphling_block_int_lua", -- modifier name
				{ duration = self.interval }
			)

			-- is INT, change to STR
			self.block_type = 0
		end
	end
end
