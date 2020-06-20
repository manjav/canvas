package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Layers.Layer;
import ir.grantech.canvas.services.Libs.LibItem;
import ir.grantech.canvas.services.Tools;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.utils.Draggable;
import openfl.Vector;
import openfl.display.GraphicsPath;
import openfl.display.IGraphicsData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;

class CanScene extends LayoutGroup {
	static public var WIDTH = 120 * CanTheme.DPI;
	static public var HEIGHT = 200 * CanTheme.DPI;
	static public var COLOR = 0xFFFFFF;

	public var beginPoint:Point;
	public var hitHint:Shape;
	public var selection:Shape;
	public var transformHint:TransformHint;
	public var container:Sprite;

	private var draggable:Draggable;

	override function initialize() {
		super.initialize();

		this.beginPoint = new Point();

		this.container = new Sprite();
		this.addChild(this.container);

		this.graphics.beginFill(0xFFFFFF);
		this.graphics.lineStyle(0.2, 0x838383);
		this.graphics.drawRect(0, 0, WIDTH, HEIGHT);

		this.hitHint = new Shape();

		this.transformHint = new TransformHint(this);

		this.selection = new Shape();

		this.selection.visible = false;
		this.addChild(this.selection);
		this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
	}

	private function enterFrameHandler(event:Event):Void {
		for (i in 0...Commands.instance.layers.length)
			Commands.instance.layers.get(i).valiadateAll();
	}

	@:access(ir.grantech.canvas.services.Inputs)
	public function performLibInsert(pointPhase:Int, beganFrom:Int, data:Dynamic):Void {
		var input = Inputs.instance;
		if (pointPhase == Inputs.PHASE_ENDED) {
			if (this.draggable != null) {
				if (input.inScene(stage.mouseX, stage.mouseY)) {
					Commands.instance.commit(Commands.ADDED, [
						Layer.TYPE_BITMAP,
						input.selectedItems.getUInt(Commands.FILL_COLOR),
						input.selectedItems.getFloat(Commands.FILL_ALPHA),
						input.selectedItems.getFloat(Commands.BORDER_SIZE),
						input.selectedItems.getUInt(Commands.BORDER_COLOR),
						input.selectedItems.getFloat(Commands.BORDER_ALPHA),
						[
							mouseX,
							mouseY,
							this.draggable.item.source.width,
							this.draggable.item.source.height
						],
						0,
						this.draggable.item.name
					]);
				}
				this.removeChild(this.draggable);
				this.draggable = null;
			}
			return;
		}

		if (pointPhase == Inputs.PHASE_BEGAN) {
			this.draggable = new Draggable(cast(data, LibItem));
			this.addChild(this.draggable);
		}

		if (this.draggable == null)
			return;

		this.draggable.x = mouseX;
		this.draggable.y = mouseY;
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
		var bounds = target.getBounds(cast(target, openfl.display.DisplayObject));
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
