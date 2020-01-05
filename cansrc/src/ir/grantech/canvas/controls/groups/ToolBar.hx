package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.ToolBarItemRenderer;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;

class ToolBar extends LayoutGroup {
	private var topList:ListView;

	override private function initialize() {
		super.initialize();
		Std.downcast(Theme.getTheme(), CanTheme).setBarStyles(this);

		this.layout = new AnchorLayout();
		var items = [];
		for (i in 0...4)
			items[i] = {text: "pen"};

		this.topList = new ListView();
		// this.topList.height
		this.topList.dataProvider = new ArrayCollection(items);
		this.topList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.topList.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.topList.layoutData = new AnchorLayoutData(0, 0, null, 0);
		this.topList.addEventListener(Event.CHANGE, this.listView_changeHandler);
		this.topList.height = width * this.topList.dataProvider.length;
		this.addChild(this.topList);

		for (i in 0...3)
			items[i] = {text: "pen"};
		var bottomList = new ListView();
		bottomList.dataProvider = new ArrayCollection(items);
		bottomList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		bottomList.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		bottomList.layoutData = new AnchorLayoutData(null, 0, 0, 0);
		bottomList.addEventListener(Event.CHANGE, this.listView_changeHandler);
		bottomList.height = width * bottomList.dataProvider.length;
		this.addChild(bottomList);
	}

	private function listView_changeHandler(event:Event):Void {
		trace("ListView selectedIndex change: " + cast(event.currentTarget, ListView).selectedIndex);
	}
}
