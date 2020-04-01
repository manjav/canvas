package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.ListView;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import ir.grantech.services.LayersService.Layer;
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

	override private function layoutGroup_addedToStageHandler(event:Event):Void {
		super.layoutGroup_addedToStageHandler(event);
		this.layersService.addEventListener(Event.CHANGE, layersService_changeHandler);
		this.listView.dataProvider = this.layersService.items;
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		this.layersService.removeEventListener(Event.CHANGE, layersService_changeHandler);
		this.listView.dataProvider = null;
	}

	private function layersService_changeHandler(event:Event):Void {}

	override private function listView_changeHandler(event:Event):Void {}
}
