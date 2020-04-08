package ir.grantech.canvas.drawables;

import flash.geom.Matrix;
import openfl.geom.Rectangle;

class CanItems {
	public var length:Int = 0;
	public var bounds:Rectangle;
	public var items:Array<ICanItem>;

	public function new(items:Array<Dynamic>) {
		this.items = new Array<ICanItem>();
		this.bounds = new Rectangle();
		for (i in items)
			this.add(cast i, false);
		this.calculateBounds();
	}

	public function add(item:ICanItem, createBounds:Bool = true):Void {
		this.length++;
		this.items.push(item);
		if (createBounds)
			this.calculateBounds();
	}

	public function remove(item:ICanItem):Bool {
		var ret = this.items.remove(item);
		if (ret) {
			this.length--;
			this.calculateBounds();
		}
		return ret;
	}

	public function get(index:Int):ICanItem {
		if (index >= this.length)
			return null;
		return this.items[index];
	}

	public function calculateBounds() {
		this.bounds.x = Math.NEGATIVE_INFINITY;
		this.bounds.y = Math.NEGATIVE_INFINITY;
		this.bounds.width = Math.NEGATIVE_INFINITY;
		this.bounds.height = Math.NEGATIVE_INFINITY;
		for (t in this.items) {
			var b = t.getBounds(t.parent);
			this.bounds.x = Math.max(this.bounds.x, b.x);
			this.bounds.y = Math.max(this.bounds.y, b.y);
			this.bounds.width = Math.max(this.bounds.width, b.x + b.width);
			this.bounds.height = Math.max(this.bounds.height, b.y + b.height);
		}
		this.bounds.width -= this.bounds.x;
		this.bounds.height -= this.bounds.y;
	}

	public function indexOf(item:ICanItem):Int {
		return this.items.indexOf(item);
	}

}
