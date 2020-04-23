package ir.grantech.canvas.drawables;

import flash.geom.Matrix;
import haxe.ds.ArraySort;
import ir.grantech.canvas.controls.groups.CanScene;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Layers.Layer;
import lime.math.RGB;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class CanItems {
	public var length(get, never):Int;

	private function get_length():Int {
		return this.items.length;
	}

	public var filled(get, never):Bool;

	public function get_filled():Bool {
		return this.length > 0;
	}

	/**
		get agreegated type of the items
	**/
	public var type(get, never):String;

	public function get_type():String {
		if (this.length < 1)
			return Layer.TYPE_NONE;

		var t = this.items[0].layer.type;
		for (i in 1...this.length)
			if (t != this.items[i].blendMode)
				return Layer.TYPE_NONE;
		return t;
	}

	/**
		Accesses the visible of the items
	**/
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

	/**
		Accesses the blendMode of the items
	**/
	@:isVar
	public var blendMode(get, set):BlendMode;

	private function get_blendMode():BlendMode {
		if (this.length < 1)
			return "";

		var b:BlendMode = this.items[0].blendMode;
		for (i in 1...this.length)
			if (b != this.items[i].blendMode)
				return "";
		return b;
	}

	private function set_blendMode(value:BlendMode):BlendMode {
		if (this.blendMode == value)
			return value;
		this.blendMode = value;
		for (item in this.items)
			item.blendMode = value;
		return value;
	}

	/**
		Accesses the fillColor of the items
	**/
	@:isVar
	public var fillColor(get, set):RGB;

	private function get_fillColor():RGB {
		if (this.length < 1)
			return 0xFFFFFF;
		var fc:RGB = this.items[0].layer.fillColor;
		for (i in 1...this.length)
			if (fc != this.items[i].layer.fillColor)
				return 0xFFFFFF;
		return fc;
	}

	private function set_fillColor(value:RGB):RGB {
		if (this.fillColor == value)
			return value;
		this.fillColor = value;
		for (item in this.items)
			item.layer.fillColor = value;
		return value;
	}

	/**
		Accesses the fillAlpha of the items
	**/
	@:isVar
	public var fillAlpha(get, set):Float = 1;

	private function get_fillAlpha():Float {
		if (this.length < 1)
			return 1.0;
		var fa:Float = this.items[0].layer.fillAlpha;
		for (i in 1...this.length)
			if (fa != this.items[i].layer.fillAlpha)
				return 1.0;
		return fa;
	}

	private function set_fillAlpha(value:Float):Float {
		if (this.fillAlpha == value)
			return value;
		this.fillAlpha = value;
		for (item in this.items)
			item.layer.fillAlpha = value;
		return value;
	}

	/**
		Accesses the borderColor of the items
	**/
	@:isVar
	public var borderColor(get, set):RGB;

	private function get_borderColor():RGB {
		if (this.length < 1)
			return 0xFFFFFF;
		var lc:RGB = this.items[0].layer.borderColor;
		for (i in 1...this.length)
			if (lc != this.items[i].layer.borderColor)
				return 0xFFFFFF;
		return lc;
	}

	private function set_borderColor(value:RGB):RGB {
		if (this.borderColor == value)
			return value;
		this.borderColor = value;
		for (item in this.items)
			item.layer.borderColor = value;
		return value;
	}

	/**
		Accesses the fillEnabled of the items
	**/
	@:isVar
	public var fillEnabled(get, set):Bool;

	private function get_fillEnabled():Bool {
		if (this.length < 1)
			return false;
		var fe = this.items[0].layer.fillEnabled;
		for (i in 1...this.length)
			if (fe != this.items[i].layer.fillEnabled)
				return false;
		return fe;
	}

	private function set_fillEnabled(value:Bool):Bool {
		if (this.fillEnabled == value)
			return value;
		this.fillEnabled = value;
		for (item in this.items)
			item.layer.fillEnabled = value;
		return value;
	}

	/**
		Accesses the borderAlpha of the items
	**/
	@:isVar
	public var borderAlpha(get, set):Float;

	private function get_borderAlpha():Float {
		if (this.length < 1)
			return 1.0;
		var la:Float = this.items[0].layer.borderAlpha;
		for (i in 1...this.length)
			if (la != this.items[i].layer.borderAlpha)
				return 1.0;
		return la;
	}

	private function set_borderAlpha(value:Float):Float {
		if (this.borderAlpha == value)
			return value;
		this.borderAlpha = value;
		for (item in this.items)
			item.layer.borderAlpha = value;
		return value;
	}

	/**
		Accesses the borderEnabled of the items
	**/
	@:isVar
	public var borderEnabled(get, set):Bool;

	private function get_borderEnabled():Bool {
		if (this.length < 1)
			return false;
		var be = this.items[0].layer.borderEnabled;
		for (i in 1...this.length)
			if (be != this.items[i].layer.borderEnabled)
				return false;
		return be;
	}

	private function set_borderEnabled(value:Bool):Bool {
		if (this.borderEnabled == value)
			return value;
		this.borderEnabled = value;
		for (item in this.items)
			item.layer.borderEnabled = value;
		return value;
	}

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

		this.items.push(item);
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
		return true;
	}

	public function removeAll(finalize:Bool = true):Void {
		while (this.length > 0)
			this.items.pop();

		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
	}

	public function remove(item:ICanItem, finalize:Bool = true):Bool {
		var ret = this.items.remove(item);
		if (!ret)
			return false;
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
		return true;
	}

	public function deleteAll():Void {
		while (this.length > 0) {
			var item = this.items.pop();
			if (item.parent != null)
				item.parent.removeChild(cast(item, DisplayObject));
		}

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
		if (this.length == 0)
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

		if (this.length == 1)
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
		if (this.length != 1)
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
		for (i in 0...this.length) {
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
		if (mode == "distr-h" || mode == "distr-v") {
			this.distribute(mode);
			return;
		}
		if (this.length == 1) {
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

	public function distribute(mode:String):Void {
		var srtd = this.items.copy();
		var bnds = new Array<Rectangle>();
		if (mode == "distr-h") {
			ArraySort.sort(srtd, (l, r) -> l.x > r.x ? 1 : -1);
			var gap = this.bounds.width;
			var len = srtd.length;
			for (i in 0...len) {
				bnds[i] = srtd[i].getBounds(srtd[i].parent);
				gap -= bnds[i].width;
			}
			gap /= (len - 1);
			var x = 0.0;
			for (i in 0...len) {
				this.stranslate(srtd[i], -bnds[i].x + this.bounds.x + x + (gap * i), 0);
				x += bnds[i].width;
			}
		} else {
			ArraySort.sort(srtd, (l, r) -> l.y > r.y ? 1 : -1);
			var gap = this.bounds.height;
			var len = srtd.length;
			for (i in 0...len) {
				bnds[i] = srtd[i].getBounds(srtd[i].parent);
				gap -= bnds[i].height;
			}
			gap /= (len - 1);
			var y = 0.0;
			for (i in 0...len) {
				this.stranslate(srtd[i], 0, -bnds[i].y + this.bounds.y + y + (gap * i));
				y += bnds[i].height;
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
