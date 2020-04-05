package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import feathers.utils.DisplayObjectRecycler;
import haxe.ds.ArraySort;
import ir.grantech.canvas.controls.items.ToolBarItemRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.services.Tools;
import openfl.Assets;
import openfl.events.Event;
import openfl.utils.AssetType;

class ToolBar extends LayoutGroup {
	private var selectedPanel(default, set):Int = -1;

	private function set_selectedPanel(value:Int):Int {
		if (this.selectedPanel == value) {
			this.bottomList.selectedIndex = this.selectedPanel = -1;
			CanEvent.dispatch(this, Event.CHANGE, this.selectedPanel);
			return this.selectedPanel;
		}
		this.selectedPanel = value;
		CanEvent.dispatch(this, Event.CHANGE, this.selectedPanel);
		return this.selectedPanel;
	}

	private var topList:ListView;
	private var bottomList:ListView;

	override private function initialize() {
		super.initialize();
		Std.downcast(Theme.getTheme(), CanTheme).setPanelStyles(this);
		ToolBarItemRenderer.SIZE = this.width;

		this.layout = new AnchorLayout();
		var icons = Assets.list(AssetType.IMAGE);
		ArraySort.sort(icons, (l, r) -> return l > r ? 1 : -1);
		var i = 0;
		var items = [];
		for (icon in icons)
			if (icon.substr(0, 8) == "toolhead" && icon.indexOf("_selected") == -1)
				items.push({index: i++, text: icon});

		this.topList = new ListView();
		this.topList.variant = ListView.VARIANT_BORDERLESS;
		this.topList.dataProvider = new ArrayCollection(items);
		this.topList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.topList.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.topList.layoutData = new AnchorLayoutData(0, 0, null, 0);
		this.topList.selectedIndex = Tools.instance.toolType;
		this.topList.addEventListener(Event.CHANGE, this.listView_changeHandler);
		this.topList.height = ToolBarItemRenderer.SIZE * this.topList.dataProvider.length + 1;
		this.addChild(this.topList);

		i = 0;
		items = [];
		for (icon in icons)
			if (icon.substr(0, 8) == "toolfoot" && icon.indexOf("_selected") == -1)
				items.push({index: i++, text: icon});
		this.bottomList = new ListView();
		this.bottomList.variant = ListView.VARIANT_BORDERLESS;
		this.bottomList.dataProvider = new ArrayCollection(items);
		this.bottomList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.bottomList.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.bottomList.layoutData = new AnchorLayoutData(null, 0, 0, 0);
		this.bottomList.addEventListener("select", this.listView_selectHandler);
		// this.bottomList.addEventListener(Event.CHANGE, this.listView_changeHandler);
		this.bottomList.height = ToolBarItemRenderer.SIZE * this.bottomList.dataProvider.length + 1;
		this.addChild(this.bottomList);
	}

	private function listView_selectHandler(event:CanEvent):Void {
		this.selectedPanel = event.data.index;
	}

	private function listView_changeHandler(event:Event):Void {
		Tools.instance.toolType = cast(event.currentTarget, ListView).selectedIndex;
	}
}
