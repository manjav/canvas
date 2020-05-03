package ir.grantech.canvas.drawables;

import flash.geom.Matrix;
import haxe.ds.ArraySort;
import ir.grantech.canvas.controls.groups.CanScene;
import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Layers.Layer;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGB;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;

class CanItems {
	public var length(get, never):Int;

	private function get_length():Int {
		return this.items.length;
	}

	public var isFill(get, never):Bool;

	public function get_isFill():Bool {
		return this.length > 0;
	}

	public var isEmpty(get, never):Bool;

	public function get_isEmpty():Bool {
		return this.length < 1;
	}

	public var isUI(get, never):Bool;

	public function get_isUI():Bool {
		return this.type == Layer.TYPE_TEXT;
	}

	/**
		get agreegated type of the items
	**/
	public var type(get, never):String;

	public function get_type():String {
		if (this.isEmpty)
			return Layer.TYPE_NONE;

		var t = this.items[0].layer.type;
		for (i in 1...this.length)
			if (t != this.items[i].layer.type)
				return Layer.TYPE_NONE;
		return t;
	}

	public function getString(key:String):String {
		return cast(this.getProperty(key), String);
	}

	public function getInt(key:String):Int {
		return cast(this.getProperty(key), Int);
	}

	public function getFloat(key:String):Float {
		return cast(this.getProperty(key), Float);
	}

	public function getBool(key:String):Bool {
		return cast(this.getProperty(key), Bool);
	}

	public function getUInt(key:String):UInt {
		return cast(this.getProperty(key), UInt);
	}

	public function getProperty(key:String):Dynamic {
		if (this.isEmpty)
			return this.props[key];

		var value = this.items[0].layer.getProperty(key);
		for (i in 1...this.length)
			if (value != this.items[i].layer.getProperty(key))
				return this.props[key];
		return value;
	}

	public function setProperty(key:String, value:Dynamic):Void {
		if (this.isEmpty)
			this.props[key] = value;
		for (item in this.items)
			item.layer.setProperty(key, value);
	}

	public var pivot:Point;
	public var pivotV:Point;
	public var bounds:Rectangle;
	public var items:Array<ICanItem>;
	public var props:Map<String, Dynamic>;

	public function new() {
		this.pivotV = new Point();
		this.pivot = new Point(0.5, 0.5);
		this.bounds = new Rectangle();
		this.items = new Array<ICanItem>();
		this.props = new Map<String, Dynamic>();

		this.setProperty(ENABLE, true);
		this.setProperty(VISIBLE, true);
		this.setProperty(ALPHA, 1.0);
		this.setProperty(BLEND_MODE, BlendMode.NORMAL);

		this.setProperty(FILL_ENABLED, true);
		this.setProperty(FILL_COLOR, 0x6868F8);
		this.setProperty(FILL_ALPHA, 1.0);
		this.setProperty(BORDER_ENABLED, true);
		this.setProperty(BORDER_SIZE, 3.0);
		this.setProperty(BORDER_COLOR, 0xFF00FF);
		this.setProperty(BORDER_ALPHA, 1.0);
		this.setProperty(CORNER_RADIUS, 0.0);

		this.setProperty(TEXT_ALIGN, TextFormatAlign.JUSTIFY);
		this.setProperty(TEXT_AUTOSIZE, 1);
		this.setProperty(TEXT_COLOR, 0xFF);
		this.setProperty(TEXT_FONT, "IRANSans Light");
		this.setProperty(TEXT_LETTERPACE, 0);
		this.setProperty(TEXT_LINESPACE, 0);
		this.setProperty(TEXT_SIZE, 12 * CanTheme.DPI);
	}

	public function add(item:ICanItem, finalize:Bool = true):Bool {
		if (this.indexOf(item) > -1)
			return false;

		this.items.push(item);
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(SELECT, [this]);
		}
		return true;
	}

	public function removeAll(finalize:Bool = true):Void {
		while (this.length > 0)
			this.items.pop();

		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(SELECT, [this]);
		}
	}

	public function remove(item:ICanItem, finalize:Bool = true):Bool {
		var ret = this.items.remove(item);
		if (!ret)
			return false;
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(SELECT, [this]);
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
		Commands.instance.commit(SELECT, [this]);
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

	public function scale(width:Float, height:Float):Void {
		var sx = width / this.bounds.width;
		var sy = height / this.bounds.height;
		for (item in this.items) {
			var mat = item.transform.matrix;
			mat.translate(-this.pivotV.x, -this.pivotV.y);
			mat.scale(sx, sy);
			mat.translate(this.pivotV.x, this.pivotV.y);
			item.transform.matrix = mat;
		}
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

	public function resize(x:Float, y:Float, width:Float, height:Float):Void {
		var px = x / this.bounds.x;
		var py = y / this.bounds.y;
		var sx = width / this.bounds.width;
		var sy = height / this.bounds.height;
		for (item in this.items) {
			item.x = x + (item.x - this.bounds.x) * px;
			item.y = y + (item.y - this.bounds.y) * py;
			item.width *= sx;
			item.height *= sy;
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
