package ir.grantech.canvas.controls.groups.sections;

import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LibItemRenderer;
import ir.grantech.canvas.services.Libs.LibItem;

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
