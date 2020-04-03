package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.ListView;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;

@:access(ir.grantech.canvas.services.Commands)
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
		this.commands.addEventListener(Commands.SELECT, this.commads_selectHandler);
		this.listView.dataProvider = this.commands.layers;
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		this.commands.removeEventListener(Commands.SELECT, this.commads_selectHandler);
		this.listView.dataProvider = null;
	}

	private function listView_changeHandler(event:Event):Void {
		if (this.listView.selectedItem != null)
			this.commands.commit(Commands.SELECT, [this.listView.selectedItem.item]);
	}

	private function commads_selectHandler(event:CanEvent):Void {
		this.listView.removeEventListener(Event.CHANGE, this.listView_changeHandler);
		this.listView.selectedItem = event.data[0] == null ? null : event.data[0].layer;
		this.listView.addEventListener(Event.CHANGE, this.listView_changeHandler);
	}
}
