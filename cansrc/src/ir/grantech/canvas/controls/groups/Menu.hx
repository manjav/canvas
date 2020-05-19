package ir.grantech.canvas.controls.groups;

import feathers.controls.ListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.controls.items.MenuItemRenderer;

class Menu extends CanSection {
	private var listView:ListView;
	override private function initialize() {
        super.initialize();
        this.layout = new AnchorLayout();

		this.listView = this.createList([{name:"123"}, {name:"wewrwerw"}], DisplayObjectRecycler.withClass(MenuItemRenderer), new AnchorLayoutData(this.padding * 6, 0, 0, 0));
		this.listView.itemToText = (item:Dynamic) -> {
			return item.name;
		};
		// this.listView.addEventListener(CanEvent.ITEM_SELECT, this.listView_itemSelectHandler);
	}
}
