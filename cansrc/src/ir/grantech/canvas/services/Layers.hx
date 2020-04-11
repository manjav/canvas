package ir.grantech.canvas.services;

import feathers.data.ArrayCollection;
import haxe.Timer;
import ir.grantech.canvas.drawables.CanBitmap;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanSprite;
import ir.grantech.canvas.drawables.ICanItem;
import openfl.geom.Point;

class Layers extends ArrayCollection<Layer> {

	/**
	 * Constructor.
	 */
	public function new() {
		super();
		this.sortCompareFunction = orderFunction;
	}

	/**
	 * Method to add layer with it's object.
	 */
	override public function add(item:Layer):Void {
		this.addAt(item, 0);
		for (i in 0...this.length)
			this.get(i).order = i;
	}

	/**
	 * Method to remove layer with it's index.
	 */
	override public function removeAt(index:Int):Layer {
		var item = this.removeAt(index);
		for (i in 0...this.length)
			this.get(i).order = i;
		return item;
	}

	private function getItemIndex(item:Layer):Int {
		return -1;
	}

	public function changeOrder(index:Int, direction:Int):Void {
		if (index + direction < 0 || index + direction > length - 1)
			return;
		var oldLayer = this.get(index);
		var newLayer = this.get(index + direction);

		var tmp:Int = oldLayer.order;
		oldLayer.order = newLayer.order;
		newLayer.order = tmp;

		this.refresh();
	}

	private function orderFunction(left:Layer, right:Layer):Int {
		return left.order - right.order;
	}
}

class Layer {
	static public final TYPE_SHAPE:String = "shape";
	static public final TYPE_SPRITE:String = "sprite";
	static public final TYPE_BITMAP:String = "bitmap";
	static public final TYPE_SLICED:String = "slicedBitmap";

	public var id(default, default):Int;
	public var order(default, default):Int;
	public var type(default, default):String;
	public var name(default, default):String;
	public var item(default, default):ICanItem;
	public var pivot(default, default):Point = new Point(0.5, 0.5);
	public var visible(default, set):Bool = true;
	public var enabled(default, set):Bool = true;

	public function new(item:ICanItem) {
		this.id = Math.floor(Timer.stamp() * 100);

		if (Std.is(item, CanShape))
			this.type = TYPE_SHAPE;
		if (Std.is(item, CanSprite))
			this.type = TYPE_SPRITE;
		if (Std.is(item, CanBitmap))
			this.type = TYPE_BITMAP;
		this.name = type + " " + id;

		this.item = item;
		this.item.layer = this;
	}

	private function set_visible(vlaue:Bool):Bool {
		if (this.visible == vlaue)
			return this.visible;
		this.visible = vlaue;
		Commands.instance.commit(Commands.VISIBLE, [this.item, vlaue]);
		return this.visible;
	}

	private function set_enabled(vlaue:Bool):Bool {
		if (this.enabled == vlaue)
			return this.enabled;
		this.enabled = vlaue;
		Commands.instance.commit(Commands.ENABLE, [this.item, vlaue]);
		return this.enabled;
	}
}
