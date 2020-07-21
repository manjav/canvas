package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import feathers.themes.steel.BaseSteelTheme;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.items.ToolBarItemRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Tools;
import openfl.events.Event;

class ToolBar extends LayoutGroup {
	private var selectedSection(default, set):Int = -1;

	private function set_selectedSection(value:Int):Int {
		if (this.selectedSection == value) {
			this.bottomList.selectedIndex = this.selectedSection = -1;
			CanEvent.dispatch(this, Event.CHANGE, -1);
			return -1;
		}
		this.selectedSection = value;
		CanEvent.dispatch(this, Event.CHANGE, this.selectedSection);
		return value;
	}

	private var topList:ListView;
	private var bottomList:ListView;

	@:access(feathers.themes.steel.BaseSteelTheme)
	override private function initialize() {
		super.initialize();
		var theme = Std.downcast(Theme.getTheme(), BaseSteelTheme);

		var skin = new RectangleSkin();
		skin.fill = SolidColor(theme.controlFillColor1);
		this.backgroundSkin = skin;
		this.layout = new AnchorLayout();
		
		ToolBarItemRenderer.SIZE = this.width;

		this.topList = new ListView();
		this.topList.variant = ListView.VARIANT_BORDERLESS;
		this.topList.dataProvider = new ArrayCollection(Tools.instance.items);
		this.topList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.topList.layoutData = new AnchorLayoutData(0, 0, null, 0);
		this.topList.addEventListener(Event.CHANGE, this.listView_changeHandler);
		this.topList.height = ToolBarItemRenderer.SIZE * this.topList.dataProvider.length + 1;
		this.topList.selectedIndex = 0;
		this.addChild(this.topList);
		this.topList.selectedIndex = Tools.instance.toolType;
		
		this.bottomList = new ListView();
		this.bottomList.variant = ListView.VARIANT_BORDERLESS;
		this.bottomList.dataProvider = new ArrayCollection([new Tool("layers"), new Tool("assets")]);
		this.bottomList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.bottomList.layoutData = new AnchorLayoutData(null, 0, 0, 0);
		this.bottomList.addEventListener(CanEvent.ITEM_SELECT, this.bottomList_itemSelectHandler);
		this.bottomList.height = ToolBarItemRenderer.SIZE * this.bottomList.dataProvider.length + 1;
		this.addChild(this.bottomList);

		this.rightList = new ListView();
		this.rightList.itemRendererRecycler = DisplayObjectRecycler.withClass(ToolBarItemRenderer);
		this.rightList.addEventListener(CanEvent.ITEM_SELECT, this.topList_itemSelectHandler);

		Tools.instance.addEventListener(Event.CHANGE, this.tools_changeHandler);
	}

	private function tools_changeHandler(event:Event):Void {
	}

	private function topList_itemSelectHandler(event:CanEvent):Void {
		var tool = cast(event.data, Tool);
		if (this.rightList.parent != null)
			this.removeChild(this.rightList);
		if (tool.children.length == 0)
			Tools.instance.type = tool.type;
		else
			showRightList(tool);
	}

	private function bottomList_itemSelectHandler(event:CanEvent):Void {
		this.selectedSection = this.bottomList.selectedIndex;
	}

	private function showRightList(tool:Tool):Void {
		this.rightList.dataProvider = new ArrayCollection(tool.children);
		this.rightList.layoutData = new AnchorLayoutData(null, -width, null, width);
		this.rightList.height = ToolBarItemRenderer.SIZE * tool.children.length + 1;
		this.addChild(this.rightList);
	}
}
