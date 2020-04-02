package ir.grantech.services;

import openfl.geom.Point;
import feathers.data.ArrayCollection;
import haxe.Timer;
import ir.grantech.canvas.drawables.CanBitmap;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanSprite;
import ir.grantech.canvas.drawables.ICanItem;
import openfl.display.Stage;

class Layers extends ArrayCollection<Layer> {

	// public var items(default, default):ArrayCollection<Layer>;
	public var selectedItem(default, set):Layer;

	private function set_selectedItem(value:Layer):Layer {
		if (this.selectedItem == value)
			return value;
		var index = this.indexOf(value);
		if (index > -1)
			this.selectedIndex = index;
		this.selectedItem = value;
		return this.selectedItem;
	}

	/**
	 * Method to select layer with index.
	 */
	public var selectedIndex(default, set):Int = -1;

	private function set_selectedIndex(value:Int):Int {
		if (this.selectedIndex == value)
			return this.selectedIndex;

		this.selectedIndex = value;
		this.selectedItem = value > -1 ? this.get(this.selectedIndex) : null;
		// CanEvent.dispatch(this, Event.SELECT);
		return this.selectedIndex;
	}

	/**
	 * Constructor.
	 */
	public function new() {
		super();
		this.sortCompareFunction = orderFunction;
	}

	/**
	 * Method to remove layer with it's object.
	 */
	override public function remove(item:Layer):Void {
		super.remove(item);
		this.selectedIndex = -1;
	}

	/**
	 * Method to remove layer with it's index.
	 */
	override public function removeAt(index:Int):Layer {
		var item = this.removeAt(index);
		if (item != null)
			this.selectedIndex = -1;
		return item;
	}

	private function getItemIndex(item:Layer):Int {
		return -1;
	}

	private function changeOrder(index:Int, direction:Int):Void {
		var oldLayer = this.get(index);
		var newLayer = this.get(index + direction);

		var tmp:Int = oldLayer.order;
		oldLayer.order = newLayer.order;
		newLayer.order = tmp;

		this.refresh();
		this.selectedItem = newLayer;
	}

	private function orderFunction(left:Layer, right:Layer):Int {
		return left.order - right.order;
	}
}

class Layer {
	static public final TYPE_SHAPE:String = "shape";
	static public final TYPE_SPRITE:String = "sprite";
	static public final TYPE_BITMAP:String = "bitmap";
	static public final TYPE_PARTICLE:String = "particle";

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
		// CanEvent.dispatch(this, Event.RENDER);
		return this.visible;
	}

	private function set_enabled(vlaue:Bool):Bool {
		if (this.enabled == vlaue)
			return this.enabled;
		this.enabled = vlaue;
		// CanEvent.dispatch(this, Event.ACTIVATE);
		return this.enabled;
	}
}
