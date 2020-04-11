package ir.grantech.canvas.drawables;

import ir.grantech.canvas.controls.groups.CanScene;
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

	public var visible(default, set):Bool = true;

	private function set_visible(value:Bool):Bool {
		if (this.visible == value)
			return value;
		this.visible = value;
		for (item in this.items)
			item.visible = value;
		return value;
	}

	public var alpha(default, set):Float = 1;

	private function set_alpha(value:Float):Float {
		if (this.alpha == value)
			return value;
		this.alpha = value;
		for (item in this.items)
			item.alpha = value;
		return value;
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

	public function add(item:ICanItem, finalize:Bool = true):Bool {
		if (this.indexOf(item) > -1)
			return false;

		++this.length;
		this.items.push(item);
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
		return true;
	}

	public function removeAll(finalize:Bool = true):Void {
		while (this.items.length > 0)
			this.items.pop();

		this.length = 0;
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
	}

	public function remove(item:ICanItem, finalize:Bool = true):Bool {
		var ret = this.items.remove(item);
		if (!ret)
			return false;
		--this.length;
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
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
		this.bounds.x = Math.POSITIVE_INFINITY;
		this.bounds.y = Math.POSITIVE_INFINITY;
		this.bounds.width = Math.NEGATIVE_INFINITY;
		this.bounds.height = Math.NEGATIVE_INFINITY;
		if (length == 0)
			return;

		for (t in this.items) {
			var b = t.getBounds(t.parent);
			this.bounds.x = Math.min(this.bounds.x, b.x);
			this.bounds.y = Math.min(this.bounds.y, b.y);
			this.bounds.width = Math.max(this.bounds.width, b.x + b.width);
			this.bounds.height = Math.max(this.bounds.height, b.y + b.height);
		}
		this.bounds.width -= this.bounds.x;
		this.bounds.height -= this.bounds.y;

		if (length == 1)
			this.pivot.setTo(this.items[0].layer.pivot.x, this.items[0].layer.pivot.y);
		else
			this.pivot.setTo(0.5, 0.5);
	}

	// perform translate with matrix
	public function translate(dx:Float, dy:Float, index:Int = -1):Void {
		if (index > -1)
			this.stranslate(this.items[index], dx, dy);
		else
			for (item in this.items)
				this.stranslate(item, dx, dy);
		this.calculateBounds();
	}

	private function stranslate(item:ICanItem, dx:Float, dy:Float):Void {
		var mat:Matrix = item.transform.matrix;
		mat.translate(dx, dy);
		item.transform.matrix = mat;
	}

	// perform scale with matrix
	public function scale(sx:Float, sy:Float):Void {
		if (length != 1)
			return;
		var mat:Matrix = this.items[0].transform.matrix;
		var angle = Math.atan2(mat.b, mat.a);
		mat.translate(-pivotV.x, -pivotV.y);
		mat.rotate(-angle);
		mat.scale(sx == 1000000 ? 1 : sx / mat.a, sy == 1000000 ? 1 : (sx == sy ? sx / mat.a : sy / mat.d));
		mat.rotate(angle);
		mat.translate(pivotV.x, pivotV.y);
		this.items[0].transform.matrix = mat;
		this.calculateBounds();
	}

	// perform rotation with matrix
	public function rotate(angle:Float):Void {
		var a = 0.0;
		for (i in 0...length) {
			var mat:Matrix = this.items[i].transform.matrix;
			mat.translate(-this.pivotV.x, -this.pivotV.y);
			if (i == 0)
				a = Math.atan2(mat.b, mat.a);
			mat.rotate(angle - a);
			mat.translate(this.pivotV.x, this.pivotV.y);
			this.items[i].transform.matrix = mat;
		}
		this.calculateBounds();
	}

	public function setDim(width:Float, height:Float):Void {
		var rx = width / this.bounds.width;
		var ry = height / this.bounds.height;
		for (item in this.items) {
			item.width *= rx;
			item.height *= ry;
			item.x = this.bounds.x + (item.x - this.bounds.x) * rx;
			item.y = this.bounds.y + (item.y - this.bounds.y) * ry;
		}
		this.calculateBounds();
	}

	public function align(mode:String):Void {
		if (length == 1) {
			var w = cast(this.items[0].parent.parent, CanScene).canWidth;
			var h = cast(this.items[0].parent.parent, CanScene).canHeight;
			switch (mode) {
				case "align-l":
					this.stranslate(this.items[0], -this.bounds.x, 0);
				case "align-c":
					this.stranslate(this.items[0], (w - this.bounds.width) * 0.5 - this.bounds.x, 0);
				case "align-r":
					this.stranslate(this.items[0], w - this.bounds.width - this.bounds.x, 0);
				case "align-t":
					this.stranslate(this.items[0], 0, -this.bounds.y);
				case "align-m":
					this.stranslate(this.items[0], 0, (h - this.bounds.height) * 0.5 - this.bounds.y);
				case "align-b":
					this.stranslate(this.items[0], 0, h - this.bounds.height - this.bounds.y);
			}
			this.calculateBounds();
			return;
		}
		var b:Rectangle;
		for (item in this.items) {
			b = item.getBounds(item.parent);
			switch (mode) {
				case "align-l":
					this.stranslate(item, -b.x + this.bounds.x, 0);
				case "align-c":
					this.stranslate(item, this.bounds.x + this.bounds.width * 0.5 - b.x - b.width * 0.5, 0);
				case "align-r":
					this.stranslate(item, this.bounds.x + this.bounds.width - b.x - b.width, 0);
				case "align-t":
					this.stranslate(item, 0, -b.y + this.bounds.y);
				case "align-m":
					this.stranslate(item, 0, this.bounds.y + this.bounds.height * 0.5 - b.y - b.height * 0.5);
				case "align-b":
					this.stranslate(item, 0, this.bounds.y + this.bounds.height - b.y - b.height);
			}
		}
		this.calculateBounds();
	}

	public function resetTransform():Void {
		for (item in this.items) {
			var mat:Matrix = item.transform.matrix;
			var r = item.getBounds(item.parent);
			mat.a = mat.d = 1;
			mat.b = mat.c = 0;
			item.transform.matrix = mat;
			item.x = r.left + r.width * 0.5 - item.width * 0.5;
			item.y = r.top + r.height * 0.5 - item.height * 0.5;
		}
		this.calculateBounds();
	}
}