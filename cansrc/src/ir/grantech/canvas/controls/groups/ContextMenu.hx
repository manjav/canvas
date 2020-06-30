package ir.grantech.canvas.controls.groups;

import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.ContextMenuItemRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Configs.Config;
import ir.grantech.canvas.themes.CanTheme;
import openfl.filters.DropShadowFilter;

class ContextMenu extends ListView {

	override private function initialize():Void {
		super.initialize();

		this.variant = ListView.VARIANT_BORDERLESS;
		this.itemRendererRecycler = DisplayObjectRecycler.withClass(ContextMenuItemRenderer);
		this.itemToText = this.menuItemToText;
		this.addEventListener(CanEvent.ITEM_SELECT, this.lists_selectHandler);
		// this.backgroundSkin = null;
		// this.addChild(this.secondaryList);
		this.dataProvider = new ArrayCollection([new Config("test"), new Config("tests"), new Config("tesst")]);
		this.width = CanTheme.DPI * 86;
		this.height = ContextMenuItemRenderer.HEIGHT * this.dataProvider.length;
		this.filters = [new DropShadowFilter(1, 90, 0, 1, 5, 5, 1, 2)];
	}

	private function menuItemToText(item:Config):String {
		return item.name;
	}

	private function lists_selectHandler(event:CanEvent):Void {
		// var itemRenderer = cast(event.target, ContextMenuItemRenderer);
		PopUpManager.removeAllPopUps();
	}
}
