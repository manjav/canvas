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
		get selected tool.
		The following example is get current tool:
		```hx
		var tool = Tools.instance.tool;
		```
		@since 1.0.0
	**/
	public var tool(get, null):Tool;

	private function get_tool():Tool {
		return this.tools.get(this.toolType);
	}

	public function new() {
		super();
		this.tools = new Map();
		this.toolType = 0;
	}
}

class Tool {
	static public final SELECT:Int = 0;
	static public final RECTANGLE:Int = 1;
	static public final ELLIPSE:Int = 2;
	static public final TEXT:Int = 3;

	public var type:Int;

	public function new(type:Int) {
		this.type = type;
	}
}
