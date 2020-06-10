package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.CanTextInput;
import feathers.controls.ListView;
import feathers.data.ListViewItemState;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import feathers.data.IFlatCollection;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.DisplayObject;
import openfl.events.Event;

class ListSection extends CanSection {
	private var data:IFlatCollection<Dynamic>;
	private var listView:ListView;
	private var searchInput:CanTextInput;
	private var itemRendererRecycler:DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject>;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();
		this.padding = CanTheme.DPI * 7;
		this.searchInput = createTextInput("zoom", new AnchorLayoutData(this.padding * 3, this.padding, null, this.padding));

		this.listView = this.createList(null, itemRendererRecycler, new AnchorLayoutData(this.padding * 6, 0, 0, 0));
		this.listView.backgroundSkin = null;
	}

	override private function layoutGroup_addedToStageHandler(event:Event):Void {
		super.layoutGroup_addedToStageHandler(event);
		this.listView.dataProvider = data;
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		this.listView.dataProvider = null;
	}
}
