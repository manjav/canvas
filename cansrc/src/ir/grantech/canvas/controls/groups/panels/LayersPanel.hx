package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.ListView;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import ir.grantech.services.LayersService.Layer;
import ir.grantech.services.CommandsService;
import ir.grantech.services.Layers.Layer;
import openfl.events.Event;

@:access(ir.grantech.services.CommandsService)
class LayersPanel extends ListPanel {
	private var listView:ListView;

	override private function initialize() {
		this.title = "LAYERS";
		super.initialize();
		this.listView = this.createList(null, DisplayObjectRecycler.withClass(LayerItemRenderer), new AnchorLayoutData(this.padding * 6, 0, 0, 0));
		this.listView.itemToText = (item:Layer) -> {
			return item.name;
		};
		this.listView.addEventListener(Event.CHANGE, this.listView_changeHandler);
	}

	override private function layoutGroup_addedToStageHandler(event:Event):Void {
		super.layoutGroup_addedToStageHandler(event);
		this.commands.addEventListener(CommandsService.SELECT, this.commads_selectHandler);
		this.listView.dataProvider = this.commands.layers;
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		this.layersService.removeEventListener(Event.CHANGE, layersService_changeHandler);
		this.listView.dataProvider = null;
	}

	private function layersService_changeHandler(event:Event):Void {}

	private function commads_selectHandler(event:CanEvent):Void {
}
