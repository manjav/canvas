package ir.grantech.canvas.controls.groups;

import feathers.controls.Callout;
import feathers.controls.ListView;
import feathers.core.PopUpManager;
import feathers.data.ArrayCollection;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.ContextMenuItemRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Configs.Config;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.Shape;
import openfl.display.Stage;
import openfl.filters.GlowFilter;

class ContextMenu extends ListView {
	static private var menu:ContextMenu;

	public var origin:Shape;

	override private function initialize():Void {
		super.initialize();

		// this.variant = ListView.VARIANT_BORDERLESS;
		this.itemRendererRecycler = DisplayObjectRecycler.withClass(ContextMenuItemRenderer);
		this.itemToText = this.menuItemToText;
		this.addEventListener(CanEvent.ITEM_SELECT, this.lists_selectHandler);
		// this.backgroundSkin = null;
		this.dataProvider = new ArrayCollection([new Config("test"), new Config("tests"), new Config("tesst")]);
		this.width = CanTheme.DPI * 86;
		this.height = ContextMenuItemRenderer.HEIGHT * this.dataProvider.length;
		this.filters = [new GlowFilter(0, 1, 5, 5, 1, 2)];
	}

	private function menuItemToText(item:Config):String {
		return item.name;
	}

	private function lists_selectHandler(event:CanEvent):Void {
		// var itemRenderer = cast(event.target, ContextMenuItemRenderer);
		PopUpManager.removeAllPopUps();
	}

	static public function show(x:Float, y:Float, stage:Stage):Void {
		if (menu == null) {
			menu = new ContextMenu();
			menu.origin = new Shape();
			menu.origin.graphics.beginFill(0, 0);
			menu.origin.graphics.drawCircle(0, 0, 2);
			stage.addChild(menu.origin);
		}

		var callout = new Callout();
		callout.backgroundSkin = null;
		callout.content = menu;
		callout.origin = menu.origin;
		callout.horizontalAlign = LEFT;
		callout.origin.x = x;
		callout.origin.y = y;
		PopUpManager.addPopUp(callout, callout.origin, false, false, null);
	}
}
