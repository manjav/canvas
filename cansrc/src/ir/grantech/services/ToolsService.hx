package ir.grantech.services;

class ToolsService extends BaseService {
	private var tools:Map<Int, Tool>;

	/**
		The singleton method of ToolsService.
		```hx
		ToolsService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):ToolsService;

	static private function get_instance():ToolsService {
		return BaseService.get(ToolsService);
	}

	/**
		set and reterive current tool type.
		The following example is set selection tool:
		```hx
		ToolsService.instance.toolType = Tool.SELECT;
		```
		@since 1.0.0
	**/
	public var toolType(default, set):Int = -1;

	private function set_toolType(value:Int):Int {
		if (this.toolType == value)
			return this.toolType;

		this.toolType = value;
		if (this.tools.exists(this.toolType))
			this.tools.set(this.toolType, new Tool(this.toolType));
		return this.toolType;
	}

	/**
		get selected tool.
		The following example is get current tool:
		```hx
		var tool = ToolsService.instance.tool;
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
	static public final LINE:Int = 3;

	public var type:Int;

	public function new(type:Int) {
		this.type = type;
	}
}
