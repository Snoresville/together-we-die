"use strict";

var m_InventoryPanels = []

// Currently hardcoded: first 6 are inventory, next 6 are stash items
var DOTA_ITEM_STASH_MIN = 6;
var DOTA_ITEM_STASH_MAX = 6;


// Gets the query unit. If the query unit is a shop,
// instead gets the player's unit
function GetQueryUnit() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();

    var isShop = false;
    var abilityCount = Entities.GetAbilityCount(queryUnit);
    for(var i = 0; i < abilityCount; i++) {
        var buff = Entities.GetAbility(queryUnit, i);
        if(Abilities.GetAbilityName(buff) == "game_shop") {
            isShop = true;
        }
    }

    if(isShop) {
        return Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    } else {
        return queryUnit;
    }
}

function UpdateInventory()
{
    var queryUnit = GetQueryUnit();
  
  for ( var i = 0; i < DOTA_ITEM_STASH_MAX; ++i )
  {
    var inventoryPanel = m_InventoryPanels[i];
    var item = Entities.GetItemInSlot( queryUnit, i );

    inventoryPanel.SetItem( item );
    inventoryPanel.SetQueryUnit(queryUnit);

    inventoryPanel.UpdateItem();
  }

}

function UpdateInventoryItem(keys)
{
  var queryUnit = GetQueryUnit();

  if (keys.unit != queryUnit) return;

  for ( var i = 0; i < DOTA_ITEM_STASH_MAX; ++i )
  {
    var inventoryPanel = m_InventoryPanels[i]
    var item = Entities.GetItemInSlot( queryUnit, i );

    inventoryPanel.SetDisabled(keys[i].disabled);
    inventoryPanel.SetItem( item );
    inventoryPanel.SetQueryUnit(queryUnit);

    inventoryPanel.UpdateItem();
  }
}

function CreateInventoryPanels()
{
  //var stashPanel = $( "#stash_row" );
  var firstRowPanel = $( "#inventory_row_1" );
  var secondRowPanel = $( "#inventory_row_2" );
  if ( !firstRowPanel || !secondRowPanel )
    return;

  //stashPanel.RemoveAndDeleteChildren();
  //if (DOTA_ITEM_STASH_MAX <= 6) {
  //	stashPanel.visible = false;
  //}
  firstRowPanel.RemoveAndDeleteChildren();
  secondRowPanel.RemoveAndDeleteChildren();
  m_InventoryPanels = [];

  for ( var i = 0; i < DOTA_ITEM_STASH_MAX; ++i )
  {
    var parentPanel = firstRowPanel;
    if ( i >= DOTA_ITEM_STASH_MIN )
    {
      parentPanel = stashPanel;
    }
    else if ( i > 2 )
    {
      parentPanel = secondRowPanel;
    }

    var inventoryPanel = new InventoryItem(parentPanel);
    inventoryPanel.SetItemSlot( i );

    m_InventoryPanels.push( inventoryPanel );
  }
}

var INVENTORY_UPDATE_INTERVAL = 0.1;

function StartInventoryUpdates() {
  $.Schedule(INVENTORY_UPDATE_INTERVAL, function() {
    StartInventoryUpdates();
  })
  UpdateInventory();
}

(function()
{
	//$.Msg('loaded dota_inventory');
  CreateInventoryPanels();
  UpdateInventory();

  GameEvents.Subscribe( "dota_inventory_changed", UpdateInventory );
  GameEvents.Subscribe( "dota_inventory_item_changed", UpdateInventory );
  GameEvents.Subscribe( "m_event_dota_inventory_changed_query_unit", UpdateInventory );
  GameEvents.Subscribe( "m_event_keybind_changed", UpdateInventory );
  GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateInventory );
  GameEvents.Subscribe( "dota_player_update_query_unit", UpdateInventory );

  GameEvents.Subscribe( "dota_inventory_get_item_info", UpdateInventoryItem );

  StartInventoryUpdates();

})();
