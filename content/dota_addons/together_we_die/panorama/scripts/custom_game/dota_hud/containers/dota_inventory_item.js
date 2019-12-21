"use strict";

/* Represents a class constructor for an "inventory" item
	Properties:
		- panel 	 || panel containing this inventory item
		- slot 		 || inventory slot this corresponds to
		- unit  	 || unit this panel belongs to
		- item 		 || item in this slot
		- isDisabled || is this item slot disabled? (e.g. unit with limited inventory size)
		- lastClick  || remembers if the last click on this slot was left/right (for delayed-doubleclick)

	("Public") Methods:
		- UpdateItem()  || Update the UI state of this panel. This should be called periodically (e.g. every 0.1s)

	Getters/Setters:
		- GetItemSlot()
		- SetItemSlot()
		- SetDisabled()
		- SetQueryUnit()
		- SetItem()

	("Private") Methods:
		- ItemShowTooltip() || Show the tooltip corresponding to the item in this slot
		- ItemHideTooltip() ||
		- ActivateItem()    || On item left click
		- DoubleClickItem() ||
		- IsInStash()		|| Does this item slot correspond to a stash item?
		- RightClickItem()  ||

		- OnDragEnter()		|| Dragging something else and we hover this panel
		- OnDragDrop()		|| Finish dragging on this panel
		- OnDragLeave()		|| Dragging something else and we leave this panel
		- OnDragStart()		|| Start dragging from this panel
		- OnDragEnd()		|| End dragging from this panel
*/

function InventoryItem(parent) {

	// ---------------------------------------------------- //
	// ------------------- Initialization ----------------- //
	// ---------------------------------------------------- //

	this.item = -1;
	this.slot = -1;
	this.unit = -1;
	this.isDisabled = false;
	this.lastClick = -1;

	this.panel = $.CreatePanel("Panel", parent, "");
    this.panel.BLoadLayoutSnippet( "inventory_item" );

	var self = this; // Scoping nonsense
					 // Else "this" might belong to someone else
					 // Used for function-within-a-function

	// ---------------------------------------------------- //
	// -------------- Update Item Properties -------------- //
	// ---------------------------------------------------- //

	// Main actual workhorse function thingy
	this.UpdateItem = function() {

		var panel = this.panel;

		var itemName = Abilities.GetAbilityName( this.item );
		var hotkey = Abilities.GetKeybind( this.item, this.unit );
		var isPassive = Abilities.IsPassive( this.item );
		var chargeCount = 0;
		var hasCharges = false;
		var altChargeCount = 0;
		var hasAltCharges = false;
	    var isHovered = panel.BHasHoverStyle();

		if (this.slot === 6 && panel.id === "stash_row"){
			var show = false;
			for (var i=6; i<12; i++){
				if (Entities.GetItemInSlot( this.unit, i ) !== -1){
					show = true;
					break;
				}
			}

			panel.visible = show;
		}

		if (!panel.visible){
			return;
		}

		if ( Items.ShowSecondaryCharges( this.item ) )
		{
			// Ward stacks display charges differently depending on their toggle state
			hasCharges = true;
			hasAltCharges = true;
			if ( Abilities.GetToggleState( this.item ) )
			{
				chargeCount = Items.GetCurrentCharges( this.item );
				altChargeCount = Items.GetSecondaryCharges( this.item );
			}
			else
			{
				altChargeCount = Items.GetCurrentCharges( this.item );
				chargeCount = Items.GetSecondaryCharges( this.item );
			}
		}
		else if ( Items.ShouldDisplayCharges( this.item ) )
		{
			hasCharges = true;
			chargeCount = Items.GetCurrentCharges( this.item );
		}

		this.panel.SetHasClass( "no_item", (this.item == -1) );
		this.panel.SetHasClass( "show_charges", hasCharges );
		this.panel.SetHasClass( "show_alt_charges", hasAltCharges );
		this.panel.SetHasClass( "is_passive", isPassive );
		this.panel.SetHasClass( "low_mana", ((this.unit !== -1) && Abilities.GetManaCost( this.item ) > Entities.GetMana(this.unit)));
	    this.panel.SetHasClass( "item_is_active", (Abilities.GetLocalPlayerActiveAbility() == this.item) && (this.item != -1));

	    this.panel.SetHasClass( "disabledSlot", (this.isDisabled));

		this.panel.FindChildTraverse("HotkeyText" ).text = hotkey;
		//$.Msg(itemName, '   hotkey: ', hotkey);
		this.panel.FindChildTraverse("ItemImage" ).itemname = itemName;
		this.panel.FindChildTraverse("ItemImage" ).contextEntityIndex = this.item;
		this.panel.FindChildTraverse("ChargeCount" ).text = chargeCount;
		this.panel.FindChildTraverse("AltChargeCount" ).text = altChargeCount;
	    this.panel.FindChildTraverse("EmptyItem" ).visible = (itemName == "");


		if ( this.item == -1 || Abilities.IsCooldownReady( this.item ) )
		{
			this.panel.SetHasClass( "cooldown_ready", true );
			this.panel.SetHasClass( "in_cooldown", false );
		}
		else
		{
			this.panel.SetHasClass( "cooldown_ready", false );
			this.panel.SetHasClass( "in_cooldown", true );
	        var cooldownLength = Abilities.GetCooldownLength( this.item );
			var cooldownRemaining = Abilities.GetCooldownTimeRemaining( this.item );
			var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
	        this.panel.FindChildTraverse("CooldownTimer" ).text = Math.ceil( cooldownRemaining );
	        if(Number.isFinite(cooldownPercent)) {
	            this.panel.FindChildTraverse("CooldownOverlay" ).style.width = cooldownPercent+"%";
	        } else {
	            this.panel.FindChildTraverse("CooldownOverlay" ).style.width = "0%";
	        }
		}
	}

	// ---------------------------------------------------- //
	// ------------- Hovering, Clicking, etc. ------------- //
	// ---------------------------------------------------- //

	//---------
	this.ItemShowTooltip = function()
	{
	    // Ignore if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		if ( self.item == -1 )
			return;

		var itemName = Abilities.GetAbilityName( self.item );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", self.panel, itemName, self.unit );
	}

	//---------
	this.ItemHideTooltip = function(){

		$.DispatchEvent( "DOTAHideAbilityTooltip", this.panel );
	}

	var lastClick = 1; // 1 right, 0 left

	//---------
	this.ActivateItem = function()	{

	    var abilityName = Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility())
	    var targetName = Abilities.GetAbilityName(self.item)

	    // Ignore if this slot is disabled
	    if ( self.isDisabled )
	        return true;

	    self.lastClick = 0;
	    if ( self.item == -1 )
	        return;

	    if (GameUI.IsAltDown()) {
	        //$.Msg('this.item: ', this.item);
	        Abilities.PingAbility( self.item )
	        return;

	    }

	      Abilities.ExecuteAbility( self.item, self.unit, false );

	}

	//---------
	this.DoubleClickItem = function()
	{
		if (self.lastClick === 0)
			ActivateItem();
	}

	this.RightClickItem = function()
	{
	    // Ignore if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		self.lastClick = 1;
		self.ItemHideTooltip();

		var bSlotInStash = self.IsInStash();
		var bControllable = Entities.IsControllableByPlayer( self.unit, Game.GetLocalPlayerID() );
		var bSellable = Items.IsSellable( self.item ) && Items.CanBeSoldByLocalPlayer( self.item );
		var bDisassemble = Items.IsDisassemblable( self.item ) && bControllable && !bSlotInStash;
		var bAlertable = Items.IsAlertableItem( self.item );
		//var bShowInShop = Items.IsPurchasable( this.item );
	    //var bDropFromStash = bSlotInStash && bControllable;
	    //var bMoveToStash = Entities.IsInRangeOfShop(this.unit, 0, true);
	    var bShowInShop = false;
	    var bDropFromStash = false;
	    var bMoveToStash = false;

		if ( !bSellable && !bDisassemble && !bShowInShop && !bDropFromStash && !bAlertable && !bMoveToStash)
		{
			// don't show a menu if there's nothing to do
			return;
		}

		var contextMenu = new InventoryContextMenu(self.panel, self.item, self.slot);
		contextMenu.SetHasClass( "bSellable", bSellable );
		contextMenu.SetHasClass( "bDisassemble", bDisassemble );
		contextMenu.SetHasClass( "bShowInShop", bShowInShop );
		contextMenu.SetHasClass( "bAlertable", bAlertable );
		//contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", bMoveToStash ); // TODO
		//contextMenu.GetContentsPanel().SetHasClass( "bDropFromStash", bDropFromStash );
	}


	// ---------------------------------------------------- //
	// ---------- Dragging Related Functionality ---------- //
	// ---------------------------------------------------- //

	this.OnDragEnter = function( a, draggedPanel )
	{
	    // Ignore the drag enter if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		var draggedItem = draggedPanel.m_DragItem;

		// only care about dragged items other than us
		if ( draggedItem === null || draggedItem == self.item )
			return true;

		// highlight this panel as a drop target
		self.panel.AddClass( "potential_drop_target" );
		return true;
	}

	this.OnDragDrop = function( panelId, draggedPanel )
	{
		//$.Msg('OnDragDrop inventory ', draggedPanel.m_contID);
		var draggedItem = draggedPanel.m_DragItem;

	    // Ignore the drop if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		// only care about dragged items other than us
		if ( draggedItem === null )
			return true;

		var dropTarget = this.panel;
		self.panel.RemoveClass( "potential_drop_target" );

		// executing a slot swap - don't drop on the world
		draggedPanel.m_DragCompleted = true;

		// item dropped on itself? don't actually do the swap (but consider the drag completed)
		if ( draggedItem == self.item )
			return true;

		var fromCont = draggedPanel.m_contID;

		//$.Msg('dragged from', this.slot);
	    //$.Msg('TEST item: ', draggedItem);
		if (fromCont == -1){
			// create the order
			var moveItemOrder =
			{
				OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
				TargetIndex: self.slot,
				AbilityIndex: draggedItem
			};
			Game.PrepareUnitOrders( moveItemOrder );
		}
		else{
			GameEvents.SendCustomGameEventToServer( "Containers_OnDragFrom", {unit:Players.GetLocalPlayerPortraitUnit(), contID:fromCont, itemID:draggedItem,
				fromSlot:draggedPanel.m_OriginalPanel.GetSlot(), toContID:-1, toSlot:self.slot} );
		}

		return true;
	}

	this.OnDragLeave = function( panelId, draggedPanel )
	{
	    // Ignore if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		var draggedItem = draggedPanel.m_DragItem;
		if ( draggedItem === null || draggedItem == self.item )
			return false;

		// un-highlight this panel
		self.panel.RemoveClass( "potential_drop_target" );
		return true;
	}

	this.OnDragStart = function( panelId, dragCallbacks )
	{
	    // Ignore if this slot is disabled
	    if ( self.isDisabled )
	        return true;

		if ( self.item == -1 )
		{
			return true;
		}

		var itemName = Abilities.GetAbilityName( self.item );

		self.ItemHideTooltip(); // tooltip gets in the way

		// create a temp panel that will be dragged around
		var displayPanel = $.CreatePanel( "DOTAItemImage", self.panel, "dragImage" );
		displayPanel.itemname = itemName;
		displayPanel.contextEntityIndex = self.item;
		displayPanel.m_DragItem = self.item;
		displayPanel.m_contID = -1;
		displayPanel.m_DragCompleted = false; // whether the drag was successful
		displayPanel.m_OriginalPanel = self.panel;
		displayPanel.unit = self.unit;

		// hook up the display panel, and specify the panel offset from the cursor
		dragCallbacks.displayPanel = displayPanel;
		dragCallbacks.offsetX = 0;
		dragCallbacks.offsetY = 0;

		// grey out the source panel while dragging
		self.panel.AddClass( "dragging_from" );
		return true;
	}

	this.OnDragEnd = function( panelId, draggedPanel )
	{
	    // Ignore if this slot is disabled
	    if ( this.isDisabled )
	        return true;


		//$.Msg('OnDragEnd');
		if (!self.IsInStash() && !draggedPanel.m_DragCompleted){
			var position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
			var entity = null;

			if (mouseEntities.length !== 0){
				for ( var e of mouseEntities )
				{
					if ( e.accurateCollision ){
						entity = e.entityIndex;
						break;
					}
				}
			}
			GameEvents.SendCustomGameEventToServer( "Containers_OnDragWorld", {unit:Players.GetLocalPlayerPortraitUnit(), contID:-1, itemID:self.item, slot:self.slot, position:position, entity:entity} );
		}

		// if the drag didn't already complete, then try dropping in the world
	    if (!draggedPanel.m_DragCompleted) {
	        Game.DropItemAtCursor( self.unit, self.item );
	    }
		// kill the display panel
		draggedPanel.DeleteAsync( 0 );

		// restore our look
		self.panel.RemoveClass( "dragging_from" );
		return true;
	}

	// ---------------------------------------------------- //
	// ------------ Assorted Setters and Getters ---------- //
	// ---------------------------------------------------- //

	this.SetItemSlot = function( itemSlot )
	{
		this.slot = itemSlot;
	}

	this.GetItemSlot = function()
	{
		return this.slot;
	}


	this.SetItem = function( item ){
		this.item = item
	}

	this.SetQueryUnit = function(queryUnit) {
		this.unit = queryUnit
	} 

	this.SetDisabled = function(isDisabled) {
	    this.isDiabled = isDisabled;
	}

	this.IsInStash = function()
	{
		var DOTA_ITEM_STASH_MIN = 6;
		return ( this.slot >= DOTA_ITEM_STASH_MIN );
	}


	// ---------------------------------------------------- //
	// ------------- Assign Handlers to Things ------------ //
	// ---------------------------------------------------- //

	// Drag and drop handlers ( also requires 'draggable="true"' in your XML, or calling panel.SetDraggable(true) )
	$.RegisterEventHandler( 'DragEnter', this.panel, this.OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', this.panel, this.OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', this.panel, this.OnDragLeave );
	$.RegisterEventHandler( 'DragStart', this.panel, this.OnDragStart );
	$.RegisterEventHandler( 'DragEnd', this.panel, this.OnDragEnd );

	// Click and hover handlers
	var itemButton = this.panel.FindChildTraverse("ItemButton");
    itemButton.SetPanelEvent("onactivate", function(){
            self.ActivateItem();
    });
    itemButton.SetPanelEvent("onmouseover", function(){
            self.ItemShowTooltip();
    });
    itemButton.SetPanelEvent("onmouseout", function(){
            self.ItemHideTooltip();
    });
    itemButton.SetPanelEvent("ondblclick", function(){
            self.DoubleClickItem();
    });
    itemButton.SetPanelEvent("oncontextmenu", function(){
            self.RightClickItem();
    });


}