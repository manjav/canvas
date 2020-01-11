package ir.grantech.canvas.controls.groups;

import feathers.controls.CanTextInput;
import feathers.controls.LayoutGroup;
import feathers.controls.colors.ColorLine;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.Shape;
import openfl.events.Event;

class CanScene extends LayoutGroup {
	public var canWidth = 320;
	public var canHeight = 480;
	public var canColor = 0xFFFFFF;
	public var rulesLayer:Shape;
	public var selectionLayer:Shape;

	override function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();

		graphics.beginFill(0xFFFFFF);
		graphics.lineStyle(0.2, 0x838383);
		graphics.drawRect(0, 0, canWidth, canHeight);

		// var backgroundSkin = new RectangleSkin();
		// backgroundSkin.fill = SolidColor(0x33);
		// this.backgroundSkin = backgroundSkin;

		var c = new ColorLine();
		c.y = 123;
		c.width = 123;
		c.height = CanTheme.CONTROL_SIZE;
		c.addEventListener(Event.CHANGE, changed);
		addChild(c);

		var txt = new CanTextInput();
		txt.layoutData = AnchorLayoutData.center();
		addChild(txt);

		this.rulesLayer = new Shape();
		this.addChild(this.rulesLayer);

		this.selectionLayer = new Shape();
		this.selectionLayer.graphics.beginFill(0x0011FF, 0.1);
		this.selectionLayer.graphics.lineStyle(0.1, 0xFFFFFF);
		this.addChild(this.selectionLayer);
	}

	function changed(e:Event):Void {
		// trace(cast(e.currentTarget, ColorPicker).data);
	}

	public function release():Void {
		this.selectionLayer.graphics.clear();
	}
}
