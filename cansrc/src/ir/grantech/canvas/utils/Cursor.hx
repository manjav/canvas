package ir.grantech.canvas.utils;

import flash.display.Sprite;
import openfl.display.Bitmap;
import openfl.ui.Mouse;
import openfl.utils.Assets;


class Cursor extends Sprite {
	static public final MODE_NONE:Int = -1;
	static public final MODE_SCALE:Int = 0;
	static public final MODE_ROTATE:Int = 1;

	private var cursorScale:Bitmap;
	private var cursorRotate:Bitmap;

	/**
		The singleton method of Cursor.
		```hx
		Cursor.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Cursor;

	static private function get_instance():Cursor {
		if( instance == null)
			instance = new Cursor();
		return instance;
	}

	public var mode(default, set):Int;

	private function set_mode(value:Int):Int {
		if (this.mode == value)
			return this.mode;
		this.mode = value;
		this.removeChildren();
		if (this.mode > MODE_NONE) {
			this.addChild(this.mode == MODE_SCALE ? this.cursorScale : this.cursorRotate);
			Mouse.hide();
			// Lib.application.window.stage.addChild(this);
		} else {
			Mouse.show();
		}
		return this.mode;
	}

	public function new() {
		super();

		this.cursorScale = new Bitmap(Assets.getBitmapData("cur-scale"));
		this.cursorScale.x = -this.cursorScale.width * 0.5;
		this.cursorScale.y = -this.cursorScale.height * 0.5;

		this.cursorRotate = new Bitmap(Assets.getBitmapData("cur-rotate"));
		this.cursorRotate.x = -this.cursorRotate.width * 0.5;
		this.cursorRotate.y = -this.cursorRotate.height * 0.5;
	}
}