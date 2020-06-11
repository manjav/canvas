package ir.grantech.canvas.controls.groups.sections;

import ir.grantech.canvas.controls.items.LibItemRenderer;
import ir.grantech.canvas.services.Libs.LibItem;
import ir.grantech.canvas.services.Layers.Layer;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import feathers.utils.DisplayObjectRecycler;

class LibsSection extends ListSection {
	override private function initialize() {
		this.title = "ASSETS";
		this.data = this.libs.items;
		this.itemRendererRecycler = DisplayObjectRecycler.withClass(LibItemRenderer);

		super.initialize();

		this.listView.itemToText = (item:LibItem) -> {
			return item.name;
		};
		// this.listView.addEventListener(CanEvent.ITEM_SELECT, this.listView_itemSelectHandler);
	}
}
