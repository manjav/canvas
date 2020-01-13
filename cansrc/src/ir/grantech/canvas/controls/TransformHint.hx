package ir.grantech.canvas.controls;

import openfl.Vector;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

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
	private var radius:Float = 4;
	private var lines:Array<Shape>;
	private var rects:Array<Shape>;
	private var circles:Array<Shape>;
	private var corners:Array<Shape>;

	public var targets:Vector<DisplayObject>;

	public function new() {
		super();
		this.mouseEnabled = false;
		this.targets = new Vector<DisplayObject>();

		this.main = new Shape();
		this.main.graphics.beginFill(0, 0);
		this.main.graphics.drawRect(0, 0, 100, 100);
		this.addChild(this.main);

		this.doubleClickEnabled = true;
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

	// public function move(evt:MouseEvent):Void {
	// 	var mouse = new Point(mouseX, mouseY);
	// 	_target.x = mouse.x + _mouseOffset.x;
	// 	_target.y = mouse.y + _mouseOffset.y;
	// 	checkItemPosition();
	// 	evt.updateAfterEvent();
	// }
}
