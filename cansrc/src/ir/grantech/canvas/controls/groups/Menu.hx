package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.controls.ListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.controls.items.MenuItemRenderer;
import ir.grantech.canvas.themes.CanTheme;
import motion.Actuate;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Menu extends CanSection {
	public var isOpen:Bool;

	private var listView:ListView;

	override private function initialize() {
		var skin = new Button();
		skin.addEventListener(MouseEvent.MOUSE_DOWN, this.skin_mouseDownHandler);
		this.backgroundSkin = skin;

		this.visible = false;
		this.layout = new AnchorLayout();

		this.listView = this.createList(configs.menuData, DisplayObjectRecycler.withClass(MenuItemRenderer), new AnchorLayoutData(0, null, 0));
		this.listView.width = 140 * CanTheme.DPI;
		this.listView.itemToText = this.menuItemToText;
		// this.listView.addEventListener(CanEvent.ITEM_SELECT, this.listView_itemSelectHandler);
	}

	@:access(Xml)
	private function menuItemToText(item:Xml):String {
		return item.attributeMap["name"];
	}

	public function toggle():Void {
		if (this.isOpen)
			this.close();
		else
			this.open();
	}

	public function open() {
		this.isOpen = true;
		this.visible = true;
		this.parent.addChild(this);
		Actuate.stop(this);
		Actuate.tween(this, 0.4, {x: 0});
	}

	public function close() {
		Actuate.stop(this);
		Actuate.tween(this, 0.4, {x: -this.listView.width}).onComplete((?p:Array<Dynamic>) -> {
			this.isOpen = false;
			this.visible = false;
		});
	}

	private function skin_mouseDownHandler(event:Event):Void {
		this.close();
	}
}
