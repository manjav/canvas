package ir.grantech.canvas.controls;

import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.drawables.CanItems;
import openfl.ui.Mouse;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.services.Inputs;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class TransformHint extends Sprite {
	static final MODE_NONE:Int = -1;
	static final MODE_REGISTER:Int = 0;
	static final MODE_TRANSLATE:Int = 1;
	static final MODE_SCALE:Int = 2;
	static final MODE_ROTATE:Int = 3;

	public function setVisible(visible:Bool, all:Bool):Void {
		if (this.lines[0].visible == visible)
			return;
		for (i in 0...8) {
			this.lines[i].visible = visible;
			this.scaleAnchores[i].visible = visible;
			this.rotateAnchores[i].visible = visible;
		}
		if (all)
			this.register.visible = visible;
		this.register.alpha = visible ? 1 : 0.5;
	}

	private var mode:Int = -1;
	private var radius:Float = 8;
	private var lineThickness:Float = 2;
	private var lineColor:UInt = 0x1692E6;

	private var main:Shape;
	private var hitAnchor:Int;
	private var register:Shape;
	private var lines:Array<Shape>;
	private var owner:DisplayObjectContainer;
	private var scaleAnchores:Array<ScaleAnchor>;
	private var rotateAnchores:Array<RotateAnchor>;
	private var mouseTranslateBegin:Point;
	private var mouseScaleBegin:Point;
	private var mouseAngleBegin:Float;
	private var scaleBegin:Point;
	private var angleBegin:Float;
	private var cursor:Cursor;

	public var targets:CanItems;

	public function new(owner:DisplayObjectContainer) {
		super();

		this.owner = owner;
		this.main = new Shape();
		this.main.graphics.beginFill(0, 0);
		this.main.graphics.drawRect(0, 0, 100, 100);
		this.addChild(this.main);

		this.doubleClickEnabled = true;
		this.mouseTranslateBegin = new Point();
		this.mouseScaleBegin = new Point();
		this.scaleBegin = new Point();

		this.register = this.addCircle(0, 0, this.radius + 1);
		this.lines = new Array<Shape>();
		this.scaleAnchores = new Array<ScaleAnchor>();
		this.rotateAnchores = new Array<RotateAnchor>();
		for (i in 0...8) {
			var sa = new ScaleAnchor(this.radius, this.lineThickness, this.lineColor);
			this.addChild(sa);
			this.scaleAnchores.push(sa);

			var ra = new RotateAnchor(this.radius, this.lineThickness, this.lineColor);
			this.addChild(ra);
			this.rotateAnchores.push(ra);

			this.lines.push(this.addLine(i == 2 || i == 3 || i == 6 || i == 7, 100));
		}
		this.lines[0].x = this.radius;
		this.lines[5].x = this.radius;
		this.lines[2].y = this.radius;
		this.lines[7].y = this.radius;

		this.cursor = new Cursor();
		this.owner.stage.addChild(this.cursor);

		this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		if (this.mode == MODE_NONE) {
			var anchor = this.getAnchor();
			if (anchor < 0 || anchor == 8 || anchor == 9) {
				this.cursor.mode = Cursor.MODE_NONE;
				return;
			}
			this.cursor.mode = anchor > 9 ? Cursor.MODE_ROTATE : Cursor.MODE_SCALE;
		}

		if (this.cursor.mode != MODE_NONE) {
			this.cursor.rotation = this.rotation + Math.atan2(this.mouseY - this.register.y, this.mouseX - this.register.x) * 180 / Math.PI;
			this.cursor.x = event.stageX;
			this.cursor.y = event.stageY;
			event.updateAfterEvent();
		}
	}

	private function doubleClickHandler(event:MouseEvent):Void {
		// if (!this.register.hitTestPoint(stage.mouseX, stage.mouseY, true))
		// 	return;
		this.targets.pivot.setTo(0.5, 0.5);
		if (this.targets.length == 1)
			this.targets.get(0).layer.pivot.setTo(0.5, 0.5);
		this.resetRegister();
	}

	private function addCircle(fillColor:UInt, fillAlpha:Float, radius:Float):Shape {
		var c:Shape = new Shape();
		c.graphics.beginFill(fillColor, fillAlpha);
		c.graphics.lineStyle(lineThickness, lineColor);
		c.graphics.drawCircle(0, 0, radius);
		this.addChild(c);
		return c;
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

	public function set(targets:CanItems):Void {
		this.targets = targets;

		if (targets.filled) {
			this.owner.addChild(this);
			this.owner.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			this.cursor.mode = Cursor.MODE_NONE;
		} else if (this.owner == parent) {
			this.owner.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			this.owner.removeChild(this);
		}

		this.updateBounds();
	}

	public function updateBounds():Void {
		this.mode = MODE_NONE;
		if (this.targets == null || !this.targets.filled)
			return;
		this.setVisible(true, true);

		var r = this.targets.get(0).rotation;
		this.targets.get(0).rotation = 0;
		var w = this.targets.get(0).width;
		var h = this.targets.get(0).height;
		this.x = this.targets.get(0).x;
		this.y = this.targets.get(0).y;
		this.rotation = this.targets.get(0).rotation = r;

		this.main.width = w;
		this.main.height = h;

		this.scaleAnchores[1].x = this.rotateAnchores[1].x = w * 0.5;
		this.scaleAnchores[2].x = this.rotateAnchores[2].x = w;
		this.scaleAnchores[3].x = this.rotateAnchores[3].x = w;
		this.scaleAnchores[3].y = this.rotateAnchores[3].y = h * 0.5;
		this.scaleAnchores[4].x = this.rotateAnchores[4].x = w;
		this.scaleAnchores[4].y = this.rotateAnchores[4].y = h;
		this.scaleAnchores[5].x = this.rotateAnchores[5].x = w * 0.5;
		this.scaleAnchores[5].y = this.rotateAnchores[5].y = h;
		this.scaleAnchores[6].x = this.rotateAnchores[6].x = 0;
		this.scaleAnchores[6].y = this.rotateAnchores[6].y = h;
		this.scaleAnchores[7].x = this.rotateAnchores[7].x = 0;
		this.scaleAnchores[7].y = this.rotateAnchores[7].y = h * 0.5;

		for (i in 0...8)
			this.drawLine(this.lines[i], i == 2 || i == 3 || i == 6 || i == 7, (i == 2 || i == 3 || i == 6 || i == 7 ? h : w) * 0.5 - this.radius * 2);

		this.lines[1].x = w * 0.5 + this.radius;
		this.lines[2].x = w;
		this.lines[3].x = w;
		this.lines[3].y = h * 0.5 + this.radius;
		this.lines[4].x = w * 0.5 + this.radius;
		this.lines[4].y = h;
		this.lines[5].y = h;
		this.lines[6].y = h * 0.5 + this.radius;

		this.resetRegister();
	}

	private function getAnchor():Int {
		if (this.register.hitTestPoint(stage.mouseX, stage.mouseY, true))
			return 8;
		for (i in 0...8)
			if (this.scaleAnchores[i].hitTestPoint(stage.mouseX, stage.mouseY, true))
				return i;
		if (this.main.hitTestPoint(stage.mouseX, stage.mouseY, true))
			return 9;
		for (i in 0...8)
			if (this.rotateAnchores[i].hitTestPoint(stage.mouseX, stage.mouseY, true))
				return 10 + i;
		return -1;
	}

	public function perform(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			// set register point
			var r:Rectangle = this.register.getBounds(parent);
			this.targets.pivotV.setTo(r.left + r.width * 0.5, r.top + r.height * 0.5);

			// detect anchores
			this.hitAnchor = this.getAnchor();
			if (this.hitAnchor < 0)
				return;
			if (this.hitAnchor < 8) {
				this.mode = MODE_SCALE;
			} else if (this.hitAnchor == 8) {
				this.mode = MODE_REGISTER;
			} else if (this.hitAnchor == 9) {
				this.mode = MODE_TRANSLATE;
			} else if (this.hitAnchor > 9) {
				this.mode = MODE_ROTATE;
				this.hitAnchor -= 10;
			}
			this.setVisible(false, this.mode == MODE_TRANSLATE);
		}

		// porform methods
		if (this.hitAnchor < 0)
			return;
		if (this.mode == MODE_REGISTER)
			this.performRegister(state);
		else if (this.mode == MODE_TRANSLATE)
			this.performTranslate(state);
		else if (this.mode == MODE_SCALE)
			this.performScale(state);
		else if (this.mode == MODE_ROTATE)
			this.performRotate(state);
	}

	private function performRegister(state:Int):Void {
		this.targets.pivot.setTo(this.mouseX / this.scaleAnchores[4].x, this.mouseY / this.scaleAnchores[4].y);
		this.snapTo(this.targets.pivot, -0.05, 0.05, -0.05, 0.05);
		this.snapTo(this.targets.pivot, 0.45, 0.55, -0.05, 0.05);
		this.snapTo(this.targets.pivot, 0.95, 1.05, -0.05, 0.05);
		this.snapTo(this.targets.pivot, -0.05, 0.05, 0.45, 0.55);
		this.snapTo(this.targets.pivot, 0.45, 0.55, 0.45, 0.55);
		this.snapTo(this.targets.pivot, 0.95, 1.05, 0.45, 0.55);
		this.snapTo(this.targets.pivot, -0.05, 0.05, 0.95, 1.05);
		this.snapTo(this.targets.pivot, 0.45, 0.55, 0.95, 1.05);
		this.snapTo(this.targets.pivot, 0.95, 1.05, 0.95, 1.05);
		if (this.targets.length == 1)
			this.targets.get(0).layer.pivot.setTo(this.targets.pivot.x, this.targets.pivot.y);
		this.resetRegister();
	}

	private function snapTo(c:Point, x1:Float, x2:Float, y1:Float, y2:Float):Void {
		if (c.x > x1 && c.x < x2 && c.y > y1 && c.y < y2)
			c.setTo(x1 + (x2 - x1) * 0.5, y1 + (y2 - y1) * 0.5);
	}

	private function resetRegister():Void {
		this.register.x = this.scaleAnchores[4].x * this.targets.pivot.x;
		this.register.y = this.scaleAnchores[4].y * this.targets.pivot.y;
	}

	private function performRotate(state:Int):Void {
		var rad = Math.atan2(this.mouseY - this.register.y, this.mouseX - this.register.x);
		if (state == Inputs.PHASE_BEGAN) {
			this.angleBegin = Math.atan2(this.targets.get(0).transform.matrix.b, this.targets.get(0).transform.matrix.a);
			this.mouseAngleBegin = rad;
			return;
		}

		// calculate destination angle
		var angle = this.angleBegin + rad - this.mouseAngleBegin;
		if (Inputs.instance.shiftKey || Inputs.instance.ctrlKey) {
			var step = Math.PI * (Inputs.instance.shiftKey ? 0.5 : 0.25);
			var mod = angle % step;
			angle += (mod > step * 0.5 ? step - mod : -mod); // snap to 90 or 45
		}
		Commands.instance.commit(Commands.ROTATE, [this.targets, angle]);
	}

	private function performScale(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			this.mouseScaleBegin.setTo(this.mouseX - this.register.x, this.mouseY - this.register.y);
			var mat:Matrix = this.targets.get(0).transform.matrix;
			this.angleBegin = Math.atan2(mat.b, mat.a);
			mat.rotate(-this.angleBegin);
			this.scaleBegin.setTo(mat.a, mat.d);
			mat.rotate(this.angleBegin);
			return;
		}

		// calculate delta scale
		var sx = this.scaleBegin.x * (this.mouseX - this.register.x) / this.mouseScaleBegin.x;
		var sy = this.scaleBegin.y * (this.mouseY - this.register.y) / this.mouseScaleBegin.y;

		if (Inputs.instance.shiftKey) {
			sy = sx;
		} else {
			if (this.hitAnchor == 1 || this.hitAnchor == 5)
				sx = 1000000;
			else if (this.hitAnchor == 3 || this.hitAnchor == 7)
				sy = 1000000;
		}
		Commands.instance.commit(Commands.SCALE, [this.targets, sx, sy, this.targets.pivotV]);
	}

	private function performTranslate(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			this.mouseTranslateBegin.setTo(stage.mouseX / Inputs.instance.zoom, stage.mouseY / Inputs.instance.zoom);
			return;
		}

		// calculate delta translate
		var tx = stage.mouseX / Inputs.instance.zoom - this.mouseTranslateBegin.x;
		var ty = stage.mouseY / Inputs.instance.zoom - this.mouseTranslateBegin.y;
		this.mouseTranslateBegin.setTo(tx + this.mouseTranslateBegin.x, ty + this.mouseTranslateBegin.y);
		Commands.instance.commit(Commands.TRANSLATE, [this.targets, tx, ty]);
	}
}

class ScaleAnchor extends Sprite {
	public function new(radius:Float, thinkness:Float, lineColor:UInt) {
		super();
		this.graphics.lineStyle(thinkness, lineColor);
		this.graphics.beginFill(0, 0);
		this.graphics.drawCircle(0, 0, radius);
	}
}

class RotateAnchor extends Shape {
	public function new(radius:Float, thinkness:Float, lineColor:UInt) {
		super();
		this.graphics.beginFill(0xFF, 0);
		this.graphics.drawCircle(0, 0, radius * 4);
	}
}

class Cursor extends Sprite {
	static public final MODE_NONE:Int = -1;
	static public final MODE_SCALE:Int = 0;
	static public final MODE_ROTATE:Int = 1;

	private var cursorScale:Bitmap;
	private var cursorRotate:Bitmap;

	public var mode(default, set):Int;

	private function set_mode(value:Int):Int {
		if (this.mode == value)
			return this.mode;
		this.mode = value;
		this.removeChildren();
		if (this.mode > MODE_NONE) {
			this.addChild(this.mode == MODE_SCALE ? this.cursorScale : this.cursorRotate);
			Mouse.hide();
		} else {
			Mouse.show();
		}
		return this.mode;
	}

	public function new() {
		super();

		this.cursorScale = new Bitmap(Assets.getBitmapData("cur-scale"));
		this.cursorScale.x = -this.cursorScale.width * 0.5;
		this.cursorScale.y = -this.cursorScale.height * 0.5;

		this.cursorRotate = new Bitmap(Assets.getBitmapData("cur-rotate"));
		this.cursorRotate.x = -this.cursorRotate.width * 0.5;
		this.cursorRotate.y = -this.cursorRotate.height * 0.5;
	}
}
