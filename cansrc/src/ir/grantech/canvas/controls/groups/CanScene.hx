package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import ir.grantech.canvas.drawables.CanShape;
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
	public var startPoint:Point;
	public var hitHint:Shape;
	public var selectHint:Shape;
	public var transformHint:TransformHint;

	override function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();
		this.startPoint = new Point();

		this.graphics.beginFill(0xFFFFFF);
		this.graphics.lineStyle(0.2, 0x838383);
		this.graphics.drawRect(0, 0, canWidth, canHeight);

		var sh = new CanShape();
		sh.graphics.beginFill(0xFFFFFF);
		sh.graphics.lineStyle(1, 0xFF00FF);
		sh.graphics.moveTo(10, 10);
		sh.graphics.lineTo(20, 10);
		sh.graphics.curveTo(20, 20, 0, 20);
		sh.graphics.drawRoundRect(0, 0, 122, 123, 42, 44);
		sh.x = 23;
		sh.y = 23;
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

		this.hitHint = new Shape();
		this.addChild(this.hitHint);

		this.transformHint = new TransformHint();
		this.transformHint.visible = false;
		this.addChild(this.transformHint);

		this.selectHint = new Shape();
		this.selectHint.graphics.beginFill(0x0066FF, 0.1);
		this.selectHint.graphics.lineStyle(0.1, 0xFFFFFF);
		this.selectHint.graphics.drawRect(0, 0, 100, 100);
		this.selectHint.visible = false;
		this.addChild(this.selectHint);
	}

	function changed(e:Event):Void {
		// trace(cast(e.currentTarget, ColorPicker).data);
	}

	public function startDraw():Void {
		this.startPoint.setTo(this.mouseX, this.mouseY);
		this.selectHint.visible = true;
		this.updateDraw();
	}

	public function updateDraw():Void {
		this.selectHint.x = this.mouseX < this.startPoint.x ? this.mouseX : this.startPoint.x;
		this.selectHint.y = this.mouseY < this.startPoint.y ? this.mouseY : this.startPoint.y;
		this.selectHint.width = Math.abs(this.mouseX - this.startPoint.x);
		this.selectHint.height = Math.abs(this.mouseY - this.startPoint.y);
	}

	public function hit(x:Float, y:Float):DisplayObject {
		for (i in 0...numChildren)
			if (this.getChildAt(i).hitTestPoint(x, y))
				return this.getChildAt(i);
		return null;
	}

	public function drawHit(target:DisplayObject):Void {
		this.hitHint.graphics.clear();
		if (target == null)
			return;
		this.hitHint.visible = true;
		this.hitHint.graphics.lineStyle(0.1 * scaleX, 0x1692E6);
		var graphicDataList:Vector<IGraphicsData>;
		if (Std.is(target, Shape))
			graphicDataList = cast(target, Shape).graphics.readGraphicsData();
		else
			graphicDataList = cast(target, Sprite).graphics.readGraphicsData();

		for (gd in graphicDataList) {
			if (Std.is(gd, GraphicsPath)) {
				var commands = cast(gd, GraphicsPath).commands;
				var data = cast(gd, GraphicsPath).data;
				var c = 0;
				var d = 0;
				while (c < commands.length) {
					if (commands[c] == 1) {
						this.hitHint.graphics.moveTo(target.x + data[d], target.y + data[d + 1]);
						d += 2;
						c++;
					} else if (commands[c] == 2) {
						this.hitHint.graphics.lineTo(target.x + data[d], target.y + data[d + 1]);
						d += 2;
						c++;
					} else if (commands[c] == 3) {
						this.hitHint.graphics.curveTo(target.x + data[d], target.y + data[d + 1], target.x + data[d + 2], target.y + data[d + 3]);
						d += 4;
						c++;
					}
				}
			}
		}
	}
}
