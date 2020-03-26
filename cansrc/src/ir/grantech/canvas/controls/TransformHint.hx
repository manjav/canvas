package ir.grantech.canvas.controls;

import ir.grantech.services.InputService;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

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

	private function setVisible(visible:Bool, all:Bool):Void {
		if (this.lines[0].visible == visible)
			return;
		for (i in 0...8) {
			this.lines[i].visible = visible;
			this.corners[i].visible = visible;
		}
		if (all)
			this.register.visible = visible;
		this.register.alpha = visible ? 1 : 0.5;
	}

	private var radius:Float = 6;
	private var lineThickness:Float = 2;
	private var lineColor:UInt = 0x1692E6;

	private var main:Shape;
	private var hitCorner:Int;
	private var register:Shape;
	private var lines:Array<Shape>;
	private var rects:Array<Shape>;
	private var circles:Array<Shape>;
	private var corners:Array<Shape>;
	private var lastPoint:Point;
	private var lastScale:Point;
	private var lastAngle:Float;
	private var registerRatio:Point;
	private var registerPoint:Point;

	public var targets:Array<DisplayObject>;

	public function new() {
		super();

		this.main = new Shape();
		this.main.graphics.beginFill(0, 0);
		this.main.graphics.drawRect(0, 0, 100, 100);
		this.addChild(this.main);

		this.doubleClickEnabled = true;
		this.lastPoint = new Point();
		this.lastScale = new Point();
		this.registerPoint = new Point();
		this.registerRatio = new Point(0.5, 0.5);
		this.targets = new Array<DisplayObject>();

		this.register = this.addCircle(0, 0, this.radius + 1);
		this.lines = new Array<Shape>();
		this.rects = new Array<Shape>();
		this.circles = new Array<Shape>();
		for (i in 0...8) {
			this.rects.push(this.addRect(0, 0, this.radius));
			this.circles.push(this.addCircle(0, 0, this.radius + 1));
			this.lines.push(this.addLine(i == 2 || i == 3 || i == 6 || i == 7, 100));
		}
		this.lines[0].x = this.radius;
		this.lines[5].x = this.radius;
		this.lines[2].y = this.radius;
		this.lines[7].y = this.radius;

		this.mode = MODE_SCALE;
		this.setVisible(false, true);
		this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
	}

	private function doubleClickHandler(event:MouseEvent):Void {
		if (this.register.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
			this.registerRatio.setTo(0.5, 0.5);
			this.resetRegister();
		}
		this.mode = this.mode == MODE_SCALE ? MODE_ROTATE : MODE_SCALE;
	}

	private function addCircle(fillColor:UInt, fillAlpha:Float, radius:Float):Shape {
		var c:Shape = new Shape();
		c.graphics.beginFill(fillColor, fillAlpha);
		c.graphics.lineStyle(lineThickness, lineColor);
		c.graphics.drawCircle(0, 0, radius);
		this.addChild(c);
		return c;
	}

	private function addRect(fillColor:UInt, fillAlpha:Float, radius:Float):Shape {
		var r:Shape = new Shape();
		r.graphics.beginFill(fillColor, fillAlpha);
		r.graphics.lineStyle(lineThickness, lineColor);
		r.graphics.drawRect(-radius, -radius, radius * 2, radius * 2);
		this.addChild(r);
		return r;
	}

	private function addLine(vertical:Bool, length:Float):Shape {
		var l:Shape = new Shape();
		this.drawLine(l, vertical, length);
		this.addChild(l);
		return l;
	}

	private function drawLine(l:Shape, vertical:Bool, length:Float):Void {
		l.graphics.clear();
		l.graphics.lineStyle(lineThickness, lineColor);
		l.graphics.moveTo(0, 0);
		l.graphics.lineTo(vertical ? 0 : length, vertical ? length : 0);
	}

	public function set(target:DisplayObject):Void {
		this.setVisible(true, true);
		this.targets = [target];
		var r = target.rotation;
		target.rotation = 0;
		var w = target.width;
		var h = target.height;
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
		this.resetRegister();

		for (i in 0...8)
			drawLine(this.lines[i], i == 2 || i == 3 || i == 6 || i == 7, (i == 2 || i == 3 || i == 6 || i == 7 ? h : w) * 0.5 - this.radius * 2);

		this.lines[1].x = w * 0.5 + this.radius;
		this.lines[2].x = w;
		this.lines[3].x = w;
		this.lines[3].y = h * 0.5 + this.radius;
		this.lines[4].x = w * 0.5 + this.radius;
		this.lines[4].y = h;
		this.lines[5].y = h;
		this.lines[6].y = h * 0.5 + this.radius;
	}

	public function perform(state:Int):Void {
		if (state == InputService.PHASE_BEGAN) {
			// set register point
			var r:Rectangle = this.register.getBounds(parent);
			this.registerPoint.setTo(r.left + r.width * 0.5, r.top + r.height * 0.5);

			// detect handles
			this.hitCorner = -1;
			if (this.register.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
				this.hitCorner = 8;
			} else {
				for (i in 0...8) {
					if (this.corners[i].hitTestPoint(stage.mouseX, stage.mouseY, true)) {
						this.hitCorner = i;
						break;
					}
				}
			}
		} else {
			this.setVisible(false, this.hitCorner == -1);
		}

		// porform methods
		if (this.hitCorner > -1) {
			if (this.hitCorner == 8)
				this.performRegister(state);
			else if (this.mode == MODE_ROTATE)
				this.performRotate(state);
			else
				this.performScale(state);
		} else {
			this.performTranslate(state);
		}
	}

	private function performRegister(state:Int):Void {
		registerRatio.setTo(this.mouseX / corners[4].x, this.mouseY / corners[4].y);
		this.resetRegister();
	}

	private function resetRegister():Void {
		this.register.x = corners[4].x * registerRatio.x;
		this.register.y = corners[4].y * registerRatio.y;
	}

	private function performRotate(state:Int):Void {
		if (state == InputService.PHASE_BEGAN) {
			this.lastAngle = Math.atan2(this.mouseY - this.register.y, this.mouseX - this.register.x);
			return;
		}

		// calculate delta angle
		var angle = Math.atan2(this.mouseY - this.register.y, this.mouseX - this.register.x);
		if (InputService.instance.shiftKey || InputService.instance.ctrlKey) {
			if (angle > Math.PI)
				angle = angle - Math.PI * 2;
			else if (angle < -Math.PI)
				angle = angle + Math.PI * 2;
			angle = Math.round(angle / (Math.PI / (InputService.instance.shiftKey ? 4.0 : 8.0)) * (Math.PI / (InputService.instance.shiftKey ? 4.0 : 8.0)));
		}
		var diff = angle - this.lastAngle;
		this.lastAngle = angle;

		// perform rotation with matrix
		var mat:Matrix = this.targets[0].transform.matrix;
		mat.translate(-registerPoint.x, -registerPoint.y);
		mat.rotate(diff);
		mat.translate(registerPoint.x, registerPoint.y);
		this.targets[0].transform.matrix = mat;
	}

	private function performScale(state:Int):Void {
		if (state == InputService.PHASE_BEGAN) {
			this.lastScale.setTo(this.mouseX - this.register.x, this.mouseY - this.register.y);
			return;
		}

		// calculate delta scale
		var sx = (this.mouseX - this.register.x) / this.lastScale.x;
		var sy = (this.mouseY - this.register.y) / this.lastScale.y;
		this.lastScale.setTo(sx * this.lastScale.x, sy * this.lastScale.y);
		
		// perform scale with matrix
		var r = this.targets[0].rotation / 180 * Math.PI;
		var mat:Matrix = this.targets[0].transform.matrix;
		mat.translate(-registerPoint.x, -registerPoint.y);
		mat.rotate(-r);
		if (InputService.instance.shiftKey) {
			mat.scale(sx, sx);
		} else {
			if (this.hitCorner == 1 || this.hitCorner == 5)
				mat.scale(1, sy);
			else if (this.hitCorner == 3 || this.hitCorner == 7)
				mat.scale(sx, 1);
			else
				mat.scale(sx, sy);
		}
		mat.rotate(r);
		mat.translate(registerPoint.x, registerPoint.y);
		this.targets[0].transform.matrix = mat;
	}

	private function performTranslate(state:Int):Void {
		if (state == InputService.PHASE_BEGAN) {
			this.lastPoint.setTo(stage.mouseX / InputService.instance.zoom, stage.mouseY / InputService.instance.zoom);
			return;
		}

		// calculate delta translate
		var tx = stage.mouseX / InputService.instance.zoom - this.lastPoint.x;
		var ty = stage.mouseY / InputService.instance.zoom - this.lastPoint.y;
		this.lastPoint.setTo(tx + this.lastPoint.x, ty + this.lastPoint.y);

		// perform translate with matrix
		var mat:Matrix = this.targets[0].transform.matrix;
		mat.translate(tx, ty);
		this.targets[0].transform.matrix = mat;
	}
}
