package ir.grantech.canvas.services;

import openfl.events.Event;
import ir.grantech.canvas.events.CanEvent;

class Tools extends BaseService {
	private var tools:Map<Int, Tool>;

	/**
		The singleton method of Tools.
		```hx
		Tools.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Tools;

	static private function get_instance():Tools {
		return BaseService.get(Tools);
	}

	/**
		set and reterive current tool type.
		The following example is set selection tool:
		```hx
		Tools.instance.toolType = Tool.SELECT;
		```
		@since 1.0.0
	**/
	public var toolType(default, set):Int = -1;

	private function set_toolType(value:Int):Int {
		if (this.toolType == value)
			return this.toolType;

		this.toolType = value;
		if (!this.tools.exists(this.toolType))
			this.tools.set(value, new Tool(value));
		CanEvent.dispatch(this, Event.CHANGE);
		//  var bmp = new CanBitmap();
		// 	bmp.bitmapData = Assets.getBitmapData("rotate");
		// 	item = bmp;
		// } else if (this.toolType == 4) {
		// 	item = new CanSlicedBitmap(Assets.getBitmapData("toolfoot_1_selected"), new Rectangle(22, 24, 4, 4));

		return value;
	}

	/**
		set and reterive current tool type.
		The following example is set selection tool:
		```hx
		Tools.instance.type = Tool.TYPE_SELECT;
		```
		@since 1.0.0
	**/
	public var type(default, set):String = null;

	private function set_type(value:String):String {
		if (this.type == value)
			return this.type;

		this.type = value;
	private function get_tool():Tool {
		return this.tools.get(this.toolType);
		CanEvent.dispatch(this, Event.CHANGE);
		return value;
	}

	public function new() {
		super();
		this.tools = new Map();
		this.toolType = 0;
	}
}

class Tool {
	static public final DIR_SELECT:String = "select";
	static public final DIR_SHAPE:String = "shape";
	static public final DIR_TEXT:String = "text";
	static public final DIR_LAYOUT:String = "layout";

	static public final TYPE_NONE:String = "none";
	static public final TYPE_SELECT:String = "select";
	static public final TYPE_RECT:String = "rect";
	static public final TYPE_ELLIPSE:String = "ellipse";
	static public final TYPE_TEXT:String = "text";
	static public final TYPE_BITMAP:String = "bitmap";
	static public final TYPE_LAYOUT:String = "layout";

	public var type:String;
	public var children:Array<Tool>;

	public function new(type:String, children:Array<Tool> = null) {
		this.type = type;
		this.children = children == null ? [] : children;
	}
}
