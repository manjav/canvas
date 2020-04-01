package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.ListView;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import openfl.events.Event;

class LayersPanel extends ListPanel {
	private var listView:ListView;

	override private function initialize() {
		this.title = "LAYERS";
		super.initialize();
		this.listView = this.createList(null, DisplayObjectRecycler.withClass(LayerItemRenderer), new AnchorLayoutData(this.padding * 6, 0, 0, 0));
		this.listView.itemToText = (item:Layer) -> {
			return item.name;
		};
	}
	override private function listView_changeHandler(event:Event):Void {}
}
