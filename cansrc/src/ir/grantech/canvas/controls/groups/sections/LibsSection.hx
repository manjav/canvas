package ir.grantech.canvas.controls.groups.sections;

import ir.grantech.canvas.services.Layers.Layer;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import feathers.utils.DisplayObjectRecycler;

class LibsSection extends ListSection {
	override private function initialize() {
		this.title = "ASSETS";
		this.data = this.commands.layers;
		this.itemRendererRecycler = DisplayObjectRecycler.withClass(LayerItemRenderer);
		
		super.initialize();

		this.listView.itemToText = (item:Layer) -> {
			return item.getString(Commands.NAME);
		};
		// this.listView.addEventListener(CanEvent.ITEM_SELECT, this.listView_itemSelectHandler);
	}

}
