card_points_lua = class({})
LinkLuaModifier( "modifier_card_points_lua", "lua_abilities/gamemode/card_points_lua/modifier_card_points_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function card_points_lua:GetIntrinsicModifierName()
	return "modifier_card_points_lua"
end

function card_points_lua:GetCP()
	if self.cardPoints == nil then
		self:SetCP(0)
	end
	return self.cardPoints
end

function card_points_lua:SetCP(points)
	self.cardPoints = points
	self:GetCaster():SetModifierStackCount("modifier_card_points_lua", self:GetCaster(), self.cardPoints)
end