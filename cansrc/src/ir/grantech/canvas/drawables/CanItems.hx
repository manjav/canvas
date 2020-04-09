package ir.grantech.canvas.drawables;

import flash.geom.Matrix;
import ir.grantech.canvas.services.Commands;
import openfl.display.BlendMode;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class CanItems {
	public var filled(get, null):Bool;

	public function get_filled():Bool {
		return length > 0;
	}

	public var alpha(default, set):Float = 1;

	private function set_alpha(value:Float):Float {
		if (this.alpha == value)
			return this.alpha;
		this.alpha = value;
		for (i in this.items)
			i.alpha = this.alpha;
		return this.alpha;
	}

	@:isVar
	public var blendMode(get, set):BlendMode;

	private function get_blendMode():BlendMode {
		if (length < 1)
			return "";

		var b:BlendMode = this.items[0].blendMode;
		for (i in 1...length)
			if (b != this.items[i].blendMode)
				return "";
		return b;
	}

	private function set_blendMode(value:BlendMode):BlendMode {
		if (this.blendMode == value)
			return value;
		this.blendMode = value;
		for (i in this.items)
			i.blendMode = value;
		return value;
	}

	public var _x:Float = Math.POSITIVE_INFINITY;
	public var length:Int = 0;
	public var bounds:Rectangle;
	public var items:Array<ICanItem>;
	public var pivot:Point;
	public var pivotV:Point;

	public function new() {
		this.items = new Array<ICanItem>();
		this.bounds = new Rectangle();
		this.pivot = new Point(0.5, 0.5);
		this.pivotV = new Point();
	}

	public function add(item:ICanItem, createBounds:Bool = true):Bool {
		if (this.indexOf(item) > -1)
			return false;

		++this.length;
		this.items.push(item);
		if (createBounds)
			this.calculateBounds();
		Commands.instance.commit(Commands.SELECT, [this]);
		return true;
	}

	public function removeAll():Void {
		while (this.items.length > 0)
			this.items.pop();

		this.length = 0;
		this.calculateBounds();
		Commands.instance.commit(Commands.SELECT, [this]);
	}

	public function remove(item:ICanItem, createBounds:Bool = true):Bool {
		var ret = this.items.remove(item);
		if (!ret)
			return false;
			this.length--;
		if (createBounds)
			this.calculateBounds();
		Commands.instance.commit(Commands.SELECT, [this]);
		return true;
	}

	public function deleteAll():Void {
		while (this.items.length > 0) {
			var i = this.items.pop();
			if (i.parent != null)
				i.parent.removeChild(cast i);
		}

		this.length = 0;
		this.calculateBounds();
		Commands.instance.commit(Commands.SELECT, [this]);
	}

	public function get(index:Int):ICanItem {
		if (index >= this.length)
			return null;
		return this.items[index];
	}

	public function indexOf(item:ICanItem):Int {
		return this.items.indexOf(item);
	}

	public function calculateBounds() {
		if (length == 1) {
			var t = this.items[0];
			this.pivot.setTo(t.layer.pivot.x, t.layer.pivot.y);
			return;
		}

		this.bounds.x = Math.NEGATIVE_INFINITY;
		this.bounds.y = Math.NEGATIVE_INFINITY;
		this.bounds.width = Math.NEGATIVE_INFINITY;
		this.bounds.height = Math.NEGATIVE_INFINITY;
		if (length == 0)
			return;

		for (t in this.items) {
			var b = t.getBounds(t.parent);
			this.bounds.x = Math.max(this.bounds.x, b.x);
			this.bounds.y = Math.max(this.bounds.y, b.y);
			this.bounds.width = Math.max(this.bounds.width, b.x + b.width);
			this.bounds.height = Math.max(this.bounds.height, b.y + b.height);
		}
		this.bounds.width -= this.bounds.x;
		this.bounds.height -= this.bounds.y;
		this.pivot.setTo(0.5, 0.5);
	}

	// perform translate with matrix
	public function translate(dx:Float, dy:Float):Void {
		for (i in this.items) {
			var mat:Matrix = i.transform.matrix;
			mat.translate(dx, dy);
			i.transform.matrix = mat;
		}
		this.calculateBounds();
	}

	// perform scale with matrix
	public function scale(sx:Float, sy:Float):Void {
		if (length != 1)
			return;
		var i = this.items[0];
			var mat:Matrix = i.transform.matrix;
			var angle = Math.atan2(mat.b, mat.a);
			mat.translate(-pivotV.x, -pivotV.y);
			mat.rotate(-angle);
			mat.scale(sx == 1000000 ? 1 : sx / mat.a, sy == 1000000 ? 1 : (sx == sy ? sx / mat.a : sy / mat.d));
			mat.rotate(angle);
			mat.translate(pivotV.x, pivotV.y);
			i.transform.matrix = mat;
		this.calculateBounds();
	}

	public function resetTransform():Void {
		for (i in this.items) {
			var mat:Matrix = i.transform.matrix;
			var r = i.getBounds(i.parent);
			mat.a = mat.d = 1;
			mat.b = mat.c = 0;
			i.transform.matrix = mat;
			i.x = r.left + r.width * 0.5 - i.width * 0.5;
			i.y = r.top + r.height * 0.5 - i.height * 0.5;
		}
		this.calculateBounds();
	}
}
