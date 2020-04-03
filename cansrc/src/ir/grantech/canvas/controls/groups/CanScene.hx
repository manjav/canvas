package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import ir.grantech.canvas.drawables.ICanItem;
import openfl.Vector;
import openfl.display.Bitmap;
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
	public var beginPoint:Point;
	public var hitHint:Shape;
	public var selectHint:Shape;
	public var transformHint:TransformHint;
	public var container:Sprite;

	override function initialize() {
		super.initialize();

		this.beginPoint = new Point();

		this.container = new Sprite();
		this.addChild(this.container);

		this.graphics.beginFill(0xFFFFFF);
		this.graphics.lineStyle(0.2, 0x838383);
		this.graphics.drawRect(0, 0, canWidth, canHeight);

		this.hitHint = new Shape();
		this.addChild(this.hitHint);

		this.transformHint = new TransformHint();
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

	public function updateSlection(begin:Bool = false):Void {
		if (begin) {
			this.selectHint.visible = true;
			this.beginPoint.setTo(this.mouseX, this.mouseY);
		}
		this.selectHint.x = this.mouseX < this.beginPoint.x ? this.mouseX : this.beginPoint.x;
		this.selectHint.y = this.mouseY < this.beginPoint.y ? this.mouseY : this.beginPoint.y;
		this.selectHint.width = Math.abs(this.mouseX - this.beginPoint.x);
		this.selectHint.height = Math.abs(this.mouseY - this.beginPoint.y);
	}

	public function drawHit(target:ICanItem):Void {
		this.hitHint.graphics.clear();
		if (target == null)
			return;
		this.hitHint.graphics.lineStyle(0.1 * scaleX, 0x1692E6);
		var graphicDataList:Vector<IGraphicsData> = null;
		if (Std.is(target, Shape)) {
			graphicDataList = cast(target, Shape).graphics.readGraphicsData();
		} else if (Std.is(target, Sprite)) {
			graphicDataList = cast(target, Sprite).graphics.readGraphicsData();
		} else if (Std.is(target, Bitmap)) {
			var bmp = cast(target, Bitmap);
			this.hitHint.graphics.drawRect(0, 0, bmp.bitmapData.width, bmp.bitmapData.height);
		}

		this.hitHint.x = target.x;
		this.hitHint.y = target.y;
		this.hitHint.rotation = target.rotation;
		this.hitHint.scaleX = target.scaleX;
		this.hitHint.scaleY = target.scaleY;
		if (graphicDataList == null)
			return;

		for (gd in graphicDataList) {
			if (Std.is(gd, GraphicsPath)) {
				var commands = cast(gd, GraphicsPath).commands;
				var data = cast(gd, GraphicsPath).data;
				var c = 0;
				var d = 0;
				while (c < commands.length) {
					if (commands[c] == 1) {
						this.hitHint.graphics.moveTo(data[d], data[d + 1]);
						d += 2;
						c++;
					} else if (commands[c] == 2) {
						this.hitHint.graphics.lineTo(data[d], data[d + 1]);
						d += 2;
						c++;
					} else if (commands[c] == 3) {
						this.hitHint.graphics.curveTo(data[d], data[d + 1], data[d + 2], data[d + 3]);
						d += 4;
						c++;
					}
				}
			}
		}
	}
}
