package ir.grantech.canvas.controls;

import ir.grantech.services.InputService;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Point;

class TransformHint extends Sprite {
	static final MODE_SCALE:Int = 0;
	static final MODE_ROTATE:Int = 1;

	public var mode(default, set):Int = -1;

	private function set_mode(value:Int):Int {
		if (this.mode == value)
			return this.mode;
		for (i in 0...8) {
			this.rects[i].visible = value == MODE_SCALE;
			this.circles[i].visible = value == MODE_ROTATE;
		}
		this.corners = value == MODE_SCALE ? this.rects : this.circles;
		if (this.targets.length > 0)
			this.set(this.targets[0]);
		return this.mode = value;
	}

	private var main:Shape;
	private var hitCorners:Bool;
	private var radius:Float = 4;
	private var lines:Array<Shape>;
	private var rects:Array<Shape>;
	private var circles:Array<Shape>;
	private var corners:Array<Shape>;
	private var beginPoint:Point;
	private var beginScale:Float;
	private var beginRotation:Float;
	private var begindistance:Float;

	public var targets:Array<DisplayObject>;

	public function new() {
		super();

		this.main = new Shape();
		this.main.graphics.beginFill(0, 0);
		this.main.graphics.drawRect(0, 0, 100, 100);
		this.addChild(this.main);

		this.doubleClickEnabled = true;
		this.beginPoint = new Point();
		this.targets = new Array<DisplayObject>();

		this.lines = new Array<Shape>();
		this.rects = new Array<Shape>();
		this.circles = new Array<Shape>();
		for (i in 0...8) {
			this.drawRect(i);
			this.drawCircle(i);
			this.drawLine(i);
		}
		this.lines[0].x = this.radius;
		this.lines[5].x = this.radius;
		this.lines[2].y = this.radius;
		this.lines[7].y = this.radius;

		this.mode = MODE_SCALE;
		this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
	}

	private function doubleClickHandler(event:MouseEvent):Void {
		this.mode = this.mode == MODE_SCALE ? MODE_ROTATE : MODE_SCALE;
	}

	private function drawCircle(i:Int):Void {
		var c:Shape = new Shape();
		c.visible = false;
		c.graphics.beginFill(0, 0);
		c.graphics.lineStyle(2, 0x1692E6);
		c.graphics.drawCircle(0, 0, this.radius + 1);
		this.circles.push(c);
		this.addChild(c);
	}

	private function drawRect(i:Int):Void {
		var r:Shape = new Shape();
		r.graphics.beginFill(0, 0);
		r.graphics.lineStyle(2, 0x1692E6);
		r.graphics.drawRect(-this.radius, -this.radius, this.radius * 2, this.radius * 2);
		this.rects.push(r);
		this.addChild(r);
	}

	private function drawLine(i:Int):Void {
		var vertical = i == 2 || i == 3 || i == 6 || i == 7;
		var l:Shape = new Shape();
		l.graphics.lineStyle(1, 0x1692E6);
		l.graphics.moveTo(0, 0);
		l.graphics.lineTo(vertical ? 0 : 100, vertical ? 100 : 0);
		this.lines.push(l);
		this.addChild(l);
	}

	public function set(target:DisplayObject):Void {
		this.targets = [target];
		var r = target.rotation;
		target.rotation = 0;
		var w = target.width - 1;
		var h = target.height - 1;
		this.x = target.x;
		this.y = target.y;
		this.rotation = target.rotation = r;

		this.main.width = w;
		this.main.height = h;

		this.corners[1].x = w * 0.5;
		this.corners[2].x = w;
		this.corners[3].x = w;
		this.corners[3].y = h * 0.5;
		this.corners[4].x = w;
		this.corners[4].y = h;
		this.corners[5].x = w * 0.5;
		this.corners[5].y = h;
		this.corners[6].x = 0;
		this.corners[6].y = h;
		this.corners[7].x = 0;
		this.corners[7].y = h * 0.5;

		for (i in 0...8)
			this.resizeLines(i, w * 0.5 - this.radius * 2, h * 0.5 - this.radius * 2);

		this.lines[1].x = w * 0.5 + this.radius;
		this.lines[2].x = w;
		this.lines[3].x = w;
		this.lines[3].y = h * 0.5 + this.radius;
		this.lines[4].x = w * 0.5 + this.radius;
		this.lines[4].y = h;
		this.lines[5].y = h;
		this.lines[6].y = h * 0.5 + this.radius;
	}

	private function resizeLines(i:Int, w:Float, h:Float):Void {
		if (i == 2 || i == 3 || i == 6 || i == 7)
			this.lines[i].height = h;
		else
			this.lines[i].width = w;
	}

	public function perform(begin:Bool = false):Void {
		if (begin) {
			this.hitCorners = false;
			this.beginPoint.setTo(stage.mouseX / InputService.instance.zoom, stage.mouseY / InputService.instance.zoom);

			// detect handles
			for (i in 0...8) {
				if (this.corners[i].hitTestPoint(stage.mouseX, stage.mouseY, true)) {
					this.hitCorners = true;
					break;
				}
			}
		}

		if (this.hitCorners) {
			if (this.mode == MODE_ROTATE)
				this.rotate(begin);
			else
				this.scale(begin);
		} else {
			this.translate();
		}
	}

	private function rotate(begin:Bool = false):Void {
		if (begin)
			this.beginRotation = this.rotation;
		var mx = stage.mouseX / InputService.instance.zoom;
		var my = stage.mouseY / InputService.instance.zoom;

		var dx1 = beginPoint.x - this.x + parent.x;
		var dy1 = beginPoint.y - this.y + parent.y;
		var ang1 = (Math.atan2(dy1, dx1) * 180) / Math.PI;
		// get angle of mouse from center //
		var dx2 = mx - this.x + parent.x;
		var dy2 = my - this.y + parent.y;
		var ang2 = (Math.atan2(dy2, dx2) * 180) / Math.PI;
		// rotate the _target and stroke the difference of the two angles //
		targets[0].rotation = this.rotation = this.beginRotation + ang2 - ang1;
	}

	private function scale(begin:Bool = false):Void {
		var mx = stage.mouseX / InputService.instance.zoom;
		var my = stage.mouseY / InputService.instance.zoom;
		var distance = Math.sqrt(Math.pow(mx - this.x + parent.x, 2) + Math.pow(my - this.y + parent.y, 2));
		if (begin) {
			this.begindistance = distance;
			this.beginScale = this.targets[0].scaleX;
		}
		this.targets[0].scaleX = this.targets[0].scaleY = this.beginScale * distance / this.begindistance;
		this.set(this.targets[0]);
	}

	private function translate():Void {
		var x = stage.mouseX / InputService.instance.zoom;
		var y = stage.mouseY / InputService.instance.zoom;

		this.targets[0].x = this.x += x - this.beginPoint.x;
		this.targets[0].y = this.y += y - this.beginPoint.y;
		this.beginPoint.setTo(x, y);
	}
}
