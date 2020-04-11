package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
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
		this.selection.graphics.beginFill(0x0066FF, 0.1);
		this.selection.graphics.lineStyle(0.1, 0xFFFFFF);
		this.selection.graphics.drawRect(0, 0, 100, 100);
		this.selection.visible = false;
		this.addChild(this.selection);
	}

	function changed(e:Event):Void {
		// trace(cast(e.currentTarget, ColorPicker).data);
	}

	@:access(ir.grantech.canvas.services.Inputs)
	public function updateSlection(phase:Int):Void {
		this.selection.visible = phase == Inputs.PHASE_UPDATE;
		if (phase == Inputs.PHASE_BEGAN) {
			this.beginPoint.setTo(this.mouseX, this.mouseY);
			this.selection.width = 0;
		} else if (phase == Inputs.PHASE_ENDED && this.selection.width > 10) {
			var selectionBounds = this.selection.getBounds(this);
			if (!Inputs.instance.shiftKey && !Inputs.instance.ctrlKey)
				Inputs.instance.selectedItems.removeAll(false);
			for (i in 0...this.container.numChildren)
				if (selectionBounds.containsRect(this.container.getChildAt(i).getBounds(this)))
					Inputs.instance.selectedItems.add(cast this.container.getChildAt(i), false);
			Inputs.instance.selectedItems.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [Inputs.instance.selectedItems]);
			return;
		}

		this.selection.x = this.mouseX < this.beginPoint.x ? this.mouseX : this.beginPoint.x;
		this.selection.y = this.mouseY < this.beginPoint.y ? this.mouseY : this.beginPoint.y;
		this.selection.width = Math.abs(this.mouseX - this.beginPoint.x);
		this.selection.height = Math.abs(this.mouseY - this.beginPoint.y);
	}

	public function drawHit(target:ICanItem):Void {
		this.hitHint.graphics.clear();
		if (target == null)
			return;
		this.hitHint.graphics.lineStyle(0.1 * scaleX, 0x1692E6);
		var graphicDataList:Vector<IGraphicsData> = null;
		if (Std.is(target, Shape) || Std.is(target, Sprite)) {
			graphicDataList = (cast target).graphics.readGraphicsData();
		} else if (Std.is(target, Bitmap)) {
			var bmp = cast(target, Bitmap);
			this.hitHint.graphics.drawRect(0, 0, bmp.bitmapData.width, bmp.bitmapData.height);
		}

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
