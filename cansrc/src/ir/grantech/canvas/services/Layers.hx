package ir.grantech.canvas.services;

import feathers.core.InvalidationFlag;
import feathers.data.ArrayCollection;
import haxe.Timer;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanText;
import ir.grantech.canvas.drawables.ICanItem;
import lime.math.RGB;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Layers extends ArrayCollection<Layer> {
	/**
	 * Constructor.
	 */
	public function new() {
		super();
		this.sortCompareFunction = this.orderFunction;
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
	static public var TYPES:Array<String>;
	static public final TYPE_NONE:String = "none";
	static public final TYPE_RECT:String = "rect";
	static public final TYPE_ELLIPSE:String = "ellipse";
	static public final TYPE_TEXT:String = "text";
	static public final TYPE_BITMAP:String = "bitmap";

	public var id(default, default):Int;
	public var order(default, default):Int;
	public var type(default, default):String;
	public var name(default, default):String;
	public var item(default, default):ICanItem;
	public var pivot(default, default):Point = new Point(0.5, 0.5);
	public var initialWidth(default, default):Float;
	public var initialHeight(default, default):Float;

	/**
		Show / Hide layer
	**/
	public var visible(default, set):Bool = true;

	private function set_visible(vlaue:Bool):Bool {
		if (this.visible == vlaue)
			return this.visible;
		this.visible = vlaue;
		Commands.instance.commit(Commands.VISIBLE, [this.item, vlaue]);
		return this.visible;
	}

	/**
		Lock / Unlock layer
	**/
	public var enabled(default, set):Bool = true;

	private function set_enabled(vlaue:Bool):Bool {
		if (this.enabled == vlaue)
			return this.enabled;
		this.enabled = vlaue;
		Commands.instance.commit(Commands.ENABLE, [this.item, vlaue]);
		return this.enabled;
	}

	/**
		fillEnabled of the item
	**/
	public var fillEnabled(default, set):Bool = true;

	private function set_fillEnabled(value:Bool):Bool {
		if (this.fillEnabled == value)
			return value;
		this.fillEnabled = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	/**
		fillColor of the item
	**/
	public var fillColor(default, set):RGB;

	private function set_fillColor(value:RGB):RGB {
		if (this.fillColor == value)
			return value;
		this.fillColor = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	/**
		fillAlpha of the item
	**/
	public var fillAlpha(default, set):Float = 1.0;

	private function set_fillAlpha(value:Float):Float {
		if (this.fillAlpha == value)
			return value;
		this.fillAlpha = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	/**
		cornerRadius of the item
	**/
	public var cornerRadius(default, set):Float = 0;

	private function set_cornerRadius(value:Float):Float {
		if (this.cornerRadius == value)
			return value;
		this.cornerRadius = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	/**
		borderSize of the item
	**/
	public var borderSize(default, set):Float = 3.0;

	private function set_borderSize(value:Float):Float {
		if (this.borderSize == value)
			return value;
		this.borderSize = value;
		this.setInvalid(InvalidationFlag.STYLES);

		return value;
	}

	/**
		borderColor of the item
	**/
	public var borderColor(default, set):RGB;

	private function set_borderColor(value:RGB):RGB {
		if (this.borderColor == value)
			return value;
		this.borderColor = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	/**
		borderAlpha of the item
	**/
	public var borderAlpha(default, set):Float = 1.0;

	private function set_borderAlpha(value:Float):Float {
		if (this.borderAlpha == value)
			return value;
		this.borderAlpha = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	
	/**
		textFormat of the item
	**/
	public var textFormat(default, set):TextFormat;

	private function set_textFormat(value:TextFormat):TextFormat {
		// if (tf_equals(value))
		// 	return value;
		if( this.type != TYPE_TEXT)
			return value;
		this.textFormat = value;
		this.setInvalid(InvalidationFlag.SKIN);
		return value;
	}

	/**
		fillEnabled of the item
	**/
	public var borderEnabled(default, set):Bool = true;

	private function set_borderEnabled(value:Bool):Bool {
		if (this.borderEnabled == value)
			return value;
		this.borderEnabled = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return value;
	}

	private var _invalidationFlags:Map<String, Bool> = new Map();

	public function new(type:Int, fillColor:RGB, fillAlpha:Float, borderSize:Float, borderColor:RGB, borderAlpha:RGB, bounds:Rectangle, borderRadius:Float) {
		if (Layer.TYPES == null)
			Layer.TYPES = [Layer.TYPE_NONE, Layer.TYPE_RECT, Layer.TYPE_ELLIPSE, Layer.TYPE_TEXT];

		this._invalidationFlags = new Map<String, Bool>();
		this.id = Math.floor(Timer.stamp() * 100);

		this.type = Layer.TYPES[type];
		this.name = type + " " + id;

		this.fillColor = fillColor;
		this.fillAlpha = fillAlpha;
		this.borderSize = borderSize;
		this.borderColor = borderColor;
		this.borderAlpha = borderAlpha;
		this.cornerRadius = cornerRadius;
		this.initialWidth = bounds.width;
		this.initialHeight = bounds.height;
		// sh.scale9Grid = new Rectangle(r, r, r, r);

		this.item = this.instantiateItem(bounds);
		this.item.layer = this;
	}

	private function instantiateItem(bounds:Rectangle):ICanItem {
		var ret:ICanItem = null;
		if (this.type == TYPE_RECT || this.type == TYPE_ELLIPSE) {
			this.fillEnabled = true;
			this.borderEnabled = true;
			var sh = new CanShape(this);
			sh.x = bounds.x;
			sh.y = bounds.y;
			ret = sh;
		} else if (this.type == TYPE_TEXT) {
			this.fillEnabled = false;
			var txt = new CanText(this);
			txt.x = bounds.x;
			txt.y = bounds.y;
			txt.width = bounds.width;
			txt.height = bounds.height;
			txt.wordWrap = txt.multiline = true;
			txt.type = TextFieldType.INPUT;
			txt.defaultTextFormat = this.textFormat = new TextFormat("IRANSans Light", 32, 0xFF, null, null, null, null, null, TextFormatAlign.JUSTIFY);
			ret = txt;
		}
		return ret;
	}

	/**
		Sets an invalidation flag. This will not add the component to the
		validation queue. It only sets the flag. A subclass might use
		this function during `draw()` to manipulate the flags that
		its superclass sees.

		@see `Layer.setInvalid()`
	**/
	public function setInvalid(flag:String):Void {
		if (this._invalidationFlags.exists(flag))
			return;
		this._invalidationFlags.set(flag, true);
	}

	/**
		Indicates whether the control is pending validation or not. By default,
		returns `true` if any invalidation flag has been set. If you pass in a
		specific flag, returns `true` only if that flag has been set (others may
		be set too, but it checks the specific flag only. If all flags have been
		marked as invalid, always returns `true`.

		The following example invalidates a component:

		```hx
		component.setInvalid();
		trace(component.isInvalid()); // true
		```
	**/
	public function isInvalid(flag:String) {
		return this._invalidationFlags.exists(flag);
	}

	/**
		Immediately validates the display object, if it is invalid. The
		validation system exists to postpone updating a display object after
		properties are changed until until the last possible moment the display
		object is rendered. This allows multiple properties to be changed at a
		time without requiring a full update every time.
	**/
	@:access(ir.grantech.canvas.drawables.ICanItem)
	public function valiadateAll() {
		this.item.update();
		this._invalidationFlags.clear();
	}
}
