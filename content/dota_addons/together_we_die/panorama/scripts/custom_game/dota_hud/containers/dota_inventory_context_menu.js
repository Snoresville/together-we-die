"use strict";

function InventoryContextMenu(parent, item, slot){ 

	this.item = item

	// The "ContextMenuScript" panel class listens to some extra dota-hud events
	// which helps e.g. ensure only one exists at a time
	this.panel = $.CreatePanel("ContextMenuScript", parent, "");
	this.panel.SetHasClass( "ContextMenu_NoArrow", true );
	this.panel.SetHasClass( "ContextMenu_NoBorder", true );
	this.panel.GetContentsPanel().style.padding = "2px";

	// Shenanigans related to the fact that ContextMenuScript for some reason
	// doesn't support BLoadLayoutSnippet
	// So we have to create it elsewhere then reparent
	// How did BMD figure out this witchcraft?
	this.tempPanel = $.CreatePanel("Panel", parent, "");
	this.tempPanel.BLoadLayoutSnippet("inventory_item_context_menu");
	this.tempPanel.SetParent(this.panel.GetContentsPanel());
	this.panel = this.tempPanel;

    var self = this; // Scoping shenanigans

	// ---------------------------------------------------- //
	// ----------------- Public Functions ----------------- //
	// ---------------------------------------------------- //

	this.SetHasClass = function(c, t)
	{
		this.panel.SetHasClass(c, t);
	}

	// ---------------------------------------------------- //
	// ------------------ Event Functions ----------------- //
	// ---------------------------------------------------- //

	this.DismissMenu = function()
	{
		$.DispatchEvent( "DismissAllContextMenus" );
	}

	this.OnSell = function()
	{
		Items.LocalPlayerSellItem(self.item );
		self.DismissMenu();
	}

	this.OnDisassemble = function()
	{
		Items.LocalPlayerDisassembleItem(self.item );
		self.DismissMenu();
	}

	this.OnShowInShop = function()
	{
		var itemName = Abilities.GetAbilityName(self.item );
		
		var itemClickedEvent = {
			"link": ( "dota.item." + itemName ),
			"shop": 0,
			"recipe": 0
		};
		GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
		self.DismissMenu();
	}

	this.OnDropFromStash = function()
	{
		Items.LocalPlayerDropItemFromStash(self.item );
		self.DismissMenu();
	}

	this.OnMoveToStash = function()
	{
		Items.LocalPlayerMoveItemToStash(self.item );
		self.DismissMenu();
	}

	this.OnAlert = function()
	{
		Items.LocalPlayerItemAlertAllies(self.item );
		self.DismissMenu();
	}


	// ---------------------------------------------------- //
	// -------------------- Assign Events ----------------- //
	// ---------------------------------------------------- //

	// Click handlers for each child
	
	var currentButton = this.panel.FindChildTraverse("ShowInShop");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnShowInShop();
    });

	currentButton = this.panel.FindChildTraverse("Sell");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnSell();
    });

	currentButton = this.panel.FindChildTraverse("Disassemble");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnDisassemble();
    });

	currentButton = this.panel.FindChildTraverse("DropFromStash");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnDropFromStash();
    });

	currentButton = this.panel.FindChildTraverse("Alert");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnAlert();
    });

	currentButton = this.panel.FindChildTraverse("MoveToStash");
    currentButton.SetPanelEvent("onactivate", function(){
            self.OnMoveToStash();
    });
	

}