package ir.grantech.canvas.services;

import ir.grantech.canvas.drawables.CanBitmap;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanSprite;
import ir.grantech.canvas.drawables.ICanItem;
import openfl.Assets;

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
		if (!this.tools.exists(this.toolType))
			this.tools.set(this.toolType, new Tool(this.toolType));
		if (this.toolType > 0 && this.toolType < 4) {

			var item:ICanItem = null;
			if (this.toolType == 1) {
				var sh = new CanShape();
				sh.graphics.beginFill(0xFFF0FF, 0.7);
				sh.graphics.lineStyle(1, 0xFF00FF);
				sh.graphics.moveTo(10, 10);
				sh.graphics.lineTo(20, 10);
				sh.graphics.curveTo(20, 20, 0, 20);
				sh.graphics.drawRoundRect(0, 0, 122, 123, 42, 44);
				item = sh;
			}
			else if(this.toolType == 2){
				var sp = new CanSprite();
				sp.graphics.beginFill(0xF0FFFF);
				sp.graphics.drawRect(0,0,100,100);
				item = sp;
			}
			else if(this.toolType == 3){
				var bmp = new CanBitmap();
				bmp.bitmapData = Assets.getBitmapData("rotate");
				item = bmp;
			}
			
			item.x = Math.random() * 320;
			item.y = Math.random() * 480;
			item.rotation = Math.random() * 360;

			this.commands.commands.commit(Commands.ADDED, [item]);
		}

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
