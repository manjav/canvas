package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import ir.grantech.services.ToolsService;
import openfl.Vector;
import openfl.display.DisplayObject;
import openfl.display.GraphicsPath;
import openfl.display.IGraphicsData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;

class CanScene extends LayoutGroup {
	public var canWidth = 320;
	public var canHeight = 480;
	public var canColor = 0xFFFFFF;
	public var rulesLayer:Shape;
	public var startPoint:Point;
	public var hitLayer:Shape;
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

		var sh = new Shape();
		// sh.graphics.beginFill(0xFFFFFF);
		sh.graphics.lineStyle(1, 0xFFFF);
		sh.graphics.drawRoundRect(12, 23, 323, 123, 42, 44);
		sh.x = 123;
		sh.y = 123;
		addChild(sh);

		// var c = new ColorLine();
		// c.y = 123;
		// c.width = 123;
		// c.height = CanTheme.CONTROL_SIZE;
		// c.addEventListener(Event.CHANGE, changed);
		// addChild(c);

		// var txt = new CanTextInput();
		// txt.layoutData = AnchorLayoutData.center();
		// addChild(txt);

		this.hitLayer = new Shape();
		this.addChild(this.hitLayer);

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

	public function drawHit(target:DisplayObject):Void {
		this.hitLayer.graphics.clear();
		this.hitLayer.graphics.lineStyle(0.2, 0x1692E6);
		var graphicDataList:Vector<IGraphicsData>;
		if (Std.is(target, Shape))
			graphicDataList = cast(target, Shape).graphics.readGraphicsData();
		else
			graphicDataList = cast(target, Sprite).graphics.readGraphicsData();

		for (gd in graphicDataList) {
			if (Std.is(gd, GraphicsPath)) {
				var data = cast(gd, GraphicsPath).data;
				var i = 2;
				this.hitLayer.graphics.moveTo(target.x + data[0], target.y + data[1]);
				while (i < data.length) {
					this.hitLayer.graphics.lineTo(target.x + data[i], target.y + data[i + 1]);
					i += 2;
				}
			}
		}
	}
}
