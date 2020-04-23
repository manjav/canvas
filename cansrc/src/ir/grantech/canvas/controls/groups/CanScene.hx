package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Tools;
import openfl.Vector;
import openfl.display.GraphicsPath;
import openfl.display.IGraphicsData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;

class CanScene extends LayoutGroup {
	public var canWidth = 640;
	public var canHeight = 960;
	public var canColor = 0xFFFFFF;
	public var beginPoint:Point;
	public var hitHint:Shape;
	public var selection:Shape;
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

		this.transformHint = new TransformHint(this);

		this.selection = new Shape();

		this.selection.visible = false;
		this.addChild(this.selection);
	}

	public function updateSlection(phase:Int, fixed:Bool):Void {
		this.selection.visible = phase == Inputs.PHASE_UPDATE;
		if (phase == Inputs.PHASE_BEGAN) {
			this.selection.graphics.clear();
			this.selection.graphics.beginFill(0x0066FF, 0.1);
			this.selection.graphics.lineStyle(0.1, 0xFFFFFF);
			if (Tools.instance.toolType == Tool.ELLIPSE)
				this.selection.graphics.drawEllipse(0, 0, 100, 100);
			else
				this.selection.graphics.drawRect(0, 0, 100, 100);
			this.selection.width = 0;
			this.beginPoint.setTo(this.mouseX, this.mouseY);
		}
		this.selection.x = this.mouseX < this.beginPoint.x ? this.mouseX : this.beginPoint.x;
		this.selection.y = this.mouseY < this.beginPoint.y ? this.mouseY : this.beginPoint.y;
		this.selection.width = Math.abs(this.mouseX - this.beginPoint.x);
		this.selection.height = Math.abs(fixed ? (this.mouseX - this.beginPoint.x) : (this.mouseY - this.beginPoint.y));
	}

	public function drawHit(target:ICanItem):Void {
		this.hitHint.graphics.clear();
		if (target == null)
			return;
		var graphicDataList:Vector<IGraphicsData> = null;
		this.hitHint.graphics.lineStyle(0.1 * scaleX, 0x1692E6);
		#if flash
		if (Std.is(target, openfl.display.Sprite)) {
			graphicDataList = cast(target, openfl.display.Sprite).graphics.readGraphicsData();
		} else if (Std.is(target, openfl.display.Shape)) {
			graphicDataList = cast(target, openfl.display.Shape).graphics.readGraphicsData();
		} else if (Std.is(target, openfl.display.Bitmap)) {
			var bmp = cast(target, openfl.display.Bitmap);
			this.hitHint.graphics.drawRect(0, 0, bmp.bitmapData.width, bmp.bitmapData.height);
		}
		#else
		var bounds = target.getBounds(cast(target, DisplayObject));
		this.hitHint.graphics.drawRect(0, 0, bounds.width, bounds.height);
		#end

		this.hitHint.x = target.x;
		this.hitHint.y = target.y;
		this.hitHint.rotation = target.rotation;
		this.hitHint.scaleX = target.scaleX;
		this.hitHint.scaleY = target.scaleY;
		this.addChild(this.hitHint);
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
