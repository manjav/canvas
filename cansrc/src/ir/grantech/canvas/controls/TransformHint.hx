package ir.grantech.canvas.controls;

import openfl.Vector;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;

class TransformHint extends Sprite {
	private var radius:Float = 4;
	private var lines:Array<Shape>;
	private var circles:Array<Shape>;

	public var targets:Vector<DisplayObject>;

	public function new() {
		super();
		this.mouseEnabled = false;
		this.targets = new Vector<DisplayObject>();

		this.lines = new Array<Shape>();
		this.circles = new Array<Shape>();
		for (i in 0...8) {
			this.drawCircle(i);
			this.drawLine(i);
		}
		this.lines[0].x = this.radius;
		this.lines[5].x = this.radius;
		this.lines[2].y = this.radius;
		this.lines[7].y = this.radius;
	}

	private function drawCircle(i:Int):Void {
		var c:Shape = new Shape();
		c.graphics.lineStyle(1, 0x1692E6);
		c.graphics.drawCircle(0, 0, this.radius);
		this.circles.push(c);
		this.addChild(c);
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

	public function set(x:Float, y:Float, w:Float, h:Float) {
		this.x = x;
		this.y = y;

		this.circles[1].x = w * 0.5;
		this.circles[2].x = w;
		this.circles[3].x = w;
		this.circles[3].y = h * 0.5;
		this.circles[4].x = w;
		this.circles[4].y = h;
		this.circles[5].x = w * 0.5;
		this.circles[5].y = h;
		this.circles[6].x = 0;
		this.circles[6].y = h;
		this.circles[7].x = 0;
		this.circles[7].y = h * 0.5;

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
