package ir.grantech.canvas.controls.groups;

import ir.grantech.services.ToolsService;
import openfl.geom.Point;
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
	public var startPoint:Point;
	public var selectionLayer:Shape;

	override function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.startPoint = new Point();

		this.graphics.beginFill(0xFFFFFF);
		this.graphics.lineStyle(0.2, 0x838383);
		this.graphics.drawRect(0, 0, canWidth, canHeight);

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
		this.selectionLayer.graphics.beginFill(0x0066FF, 0.1);
		this.selectionLayer.graphics.lineStyle(0.1, 0xFFFFFF);
		this.selectionLayer.graphics.drawRect(0, 0, 100, 100);
		this.selectionLayer.visible = false;
		this.addChild(this.selectionLayer);
	}

	function changed(e:Event):Void {
		// trace(cast(e.currentTarget, ColorPicker).data);
	}

	public function startDraw():Void {
		this.startPoint.setTo(this.mouseX, this.mouseY);
		if (ToolsService.instance.toolType == Tool.SELECT)
			this.selectionLayer.visible = true;
		this.updateDraw();
	}

	public function updateDraw():Void {
		if (ToolsService.instance.toolType == Tool.SELECT) {
			this.selectionLayer.x = this.mouseX < this.startPoint.x ? this.mouseX : this.startPoint.x;
			this.selectionLayer.y = this.mouseY < this.startPoint.y ? this.mouseY : this.startPoint.y;
			this.selectionLayer.width = Math.abs(this.mouseX - this.startPoint.x);
			this.selectionLayer.height = Math.abs(this.mouseY - this.startPoint.y);
			return;
		}
	}

	public function stopDraw():Void {
		this.selectionLayer.visible = false;
	}
}
