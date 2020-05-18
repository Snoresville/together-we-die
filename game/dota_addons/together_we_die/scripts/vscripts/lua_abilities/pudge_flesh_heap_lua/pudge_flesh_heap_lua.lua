pudge_flesh_heap_lua = class({})
LinkLuaModifier( "modifier_pudge_flesh_heap_lua", "lua_abilities/pudge_flesh_heap_lua/modifier_pudge_flesh_heap_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function pudge_flesh_heap_lua:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("flesh_heap_range")
end
--------------------------------------------------------------------------------

function pudge_flesh_heap_lua:GetIntrinsicModifierName()
	return "modifier_pudge_flesh_heap_lua"
end
 
--------------------------------------------------------------------------------

function pudge_flesh_heap_lua:GetFleshHeapKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end

function pudge_flesh_heap_lua:IncrementFleshHeapKills()
	if self:GetCaster():GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		self.nKills = self:GetFleshHeapKills() + 2
	else
		self.nKills = self:GetFleshHeapKills() + 1
	end

end