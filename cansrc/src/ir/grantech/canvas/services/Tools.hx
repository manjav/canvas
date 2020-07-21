package ir.grantech.canvas.services;

import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Tools.Tool.*;
import openfl.events.Event;

class Tools extends BaseService {
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

	public var index(default, default):Int = 0;

	/**
		set and reterive current category.
		The following example is set selection tool:
		```hx
		Tools.instance.category = Tool.CATE_SELECT;
		```
		@since 1.0.0
	**/
	public var category(default, default):Tool = null;

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
		this.index = this.findToolIndex(value);
		this.category = this.index > -1 ? this.items[this.index] : null;
		CanEvent.dispatch(this, Event.CHANGE);
		return value;
	}

	public var items:Array<Tool>;

	public function new() {
		super();
		this.items = [
			new Tool(CATE_SELECT),
			new Tool(CATE_SHAPE, [new Tool(TYPE_RECT), new Tool(TYPE_ELLIPSE)]),
			new Tool(CATE_TEXT),
			new Tool(CATE_LAYOUT, [new Tool(TYPE_BITMAP)])
		];
		this.type = TYPE_SELECT;
	}

	private function findToolIndex(type:String):Int {
		for (i in 0...items.length) {
			if (items[i].children.length == 0) {
				if (items[i].type == type)
					return i;
				continue;
			}
			for (t in items[i].children)
				if (t.type == type)
					return i;
		}
		return -1;
	}
}

class Tool {
	static public final CATE_SELECT:String = "select";
	static public final CATE_SHAPE:String = "shape";
	static public final CATE_TEXT:String = "text";
	static public final CATE_LAYOUT:String = "layout";

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
