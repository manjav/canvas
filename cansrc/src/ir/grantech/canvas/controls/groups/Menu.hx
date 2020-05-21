package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.controls.ListView;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import ir.grantech.canvas.controls.groups.sections.CanSection;
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

	public function toggle():Void {
		if (this.isOpen)
			this.close();
		else
			this.open();
	}

	public function open() {
		this.visible = true;
		this.isOpen = true;
		this.parent.addChild(this);
		Actuate.stop(this);
		Actuate.tween(this, 0.4, {x: 0});
	}

	public function close() {
		Actuate.stop(this);
			Actuate.tween(this, 0.4, {x: -this.width}).onComplete((?p:Array<Dynamic>) -> {
			this.isOpen = false;
			this.visible = false;
			});
	}

	private function skin_mouseDownHandler(event:Event):Void {
		this.close();
	}
}
