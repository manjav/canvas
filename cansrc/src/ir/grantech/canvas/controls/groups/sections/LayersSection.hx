package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.ListView;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.LayerItemRenderer;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;

@:access(ir.grantech.canvas.services.Commands)
class LayersSection extends ListSection {
	private var listView:ListView;

	override private function initialize() {
		this.title = "LAYERS";
		super.initialize();
		this.listView = this.createList(null, DisplayObjectRecycler.withClass(LayerItemRenderer), new AnchorLayoutData(this.padding * 6, 0, 0, 0));
		this.listView.itemToText = (item:Layer) -> {
			return item.name;
		};
		this.listView.addEventListener(CanEvent.ITEM_SELECT, this.listView_itemSelectHandler);
		this.listView.backgroundSkin = null;
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

	@:access(ir.grantech.canvas.services.Inputs)
	private function listView_itemSelectHandler(event:CanEvent):Void {
		Inputs.instance.selectedItems.removeAll();
		Inputs.instance.selectedItems.add(cast(event.data.item, ICanItem));
	}

	private function commads_selectHandler(event:CanEvent):Void {
		var items = cast(event.data[0], CanItems);
		this.listView.selectedItem = items.isFill ? items.get(0).layer : null;
	}
}
