package ir.grantech.canvas.services;

import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import ir.grantech.canvas.drawables.CanBitmap;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanSlicedBitmap;
import ir.grantech.canvas.drawables.CanSprite;
import ir.grantech.canvas.drawables.CanText;
import ir.grantech.canvas.drawables.ICanItem;
import openfl.Assets;
import openfl.geom.Rectangle;

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
			this.tools.set(this.toolType, new Tool(this.toolType));
		if (this.toolType > 0 && this.toolType < 6) {
			var item:ICanItem = null;
			var f = Math.round(Math.random() * 0xFFFFFF);
			var l = Math.round(Math.random() * 0xFFFFFF);
			var r = 10 + Math.random() * 50;
			if (this.toolType == 1) {
				var sh = new CanShape();
				sh.graphics.beginFill(f);
				sh.graphics.lineStyle(1, l);
				sh.graphics.drawRoundRect(0, 0, r * 3, r * 3, r, r);
				sh.scale9Grid = new Rectangle(r, r, r, r);
				item = sh;
			} else if (this.toolType == 2) {
				var sp = new CanSprite();
				sp.graphics.beginFill(f);
				sp.graphics.lineStyle(1, l);
				sp.graphics.drawCircle(r, r, r);
				item = sp;
			} else if (this.toolType == 3) {
				var bmp = new CanBitmap();
				bmp.bitmapData = Assets.getBitmapData("rotate");
				item = bmp;
			} else if (this.toolType == 4) {
				item = new CanSlicedBitmap(Assets.getBitmapData("toolfoot_1_selected"), new Rectangle(22, 24, 4, 4));
			} else if (this.toolType == 5) {
				var txt = new CanText();
				txt.defaultTextFormat = new TextFormat(Assets.getFont("IRANSans").fontName, 32, 0xFF);
				txt.type = TextFieldType.INPUT;
				txt.border = true;
				txt.embedFonts = true;
				txt.text = "123";
				item = txt;
			}

			item.x = Math.random() * 320;
			item.y = Math.random() * 480;
			item.rotation = Math.random() * 360;

			this.commands.commands.commit(Commands.ADDED, [item]);
			this.toolType = 0;
		}

		return this.toolType;
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
	static public final LINE:Int = 3;

	public var type:Int;

	public function new(type:Int) {
		this.type = type;
	}
}
