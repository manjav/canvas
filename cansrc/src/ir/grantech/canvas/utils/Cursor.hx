package ir.grantech.canvas.utils;

import openfl.ui.MouseCursor;
import flash.display.Sprite;
import openfl.display.Bitmap;
import openfl.ui.Mouse;
import openfl.utils.Assets;


class Cursor extends Sprite {
	static public final MODE_TEXT:Int = -2;
	static public final MODE_NONE:Int = -1;
	static public final MODE_SCALE:Int = 0;
	static public final MODE_ROTATE:Int = 1;
	static public final MODE_RECTANGLE:Int = 2;
	static public final MODE_ELLIPSE:Int = 3;

	private var cursorScale:Bitmap;
	private var cursorRotate:Bitmap;
	private var cursorRectangle:Bitmap;
	private var cursorEllipse:Bitmap;

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
			this.addChild(this.getIcon());
			Mouse.hide();
			// Lib.application.window.stage.addChild(this);
		} else {
			Mouse.show();
			Mouse.cursor = this.mode == MODE_TEXT ? MouseCursor.IBEAM : MouseCursor.AUTO;
		}
		return this.mode;
	}

	public function new() {
		super();
		mouseEnabled = false;

		this.cursorScale = new Bitmap(Assets.getBitmapData("cur-scale"));
		this.cursorScale.x = -this.cursorScale.width * 0.5;
		this.cursorScale.y = -this.cursorScale.height * 0.5;

		this.cursorRotate = new Bitmap(Assets.getBitmapData("cur-rotate"));
		this.cursorRotate.x = -this.cursorRotate.width * 0.5;
		this.cursorRotate.y = -this.cursorRotate.height * 0.5;

		this.cursorRectangle = new Bitmap(Assets.getBitmapData("cur-rect"));
		this.cursorRectangle.x = -this.cursorRectangle.width * 0.5;
		this.cursorRectangle.y = -this.cursorRectangle.height * 0.5;

		this.cursorEllipse = new Bitmap(Assets.getBitmapData("cur-oval"));
		this.cursorEllipse.x = -this.cursorEllipse.width * 0.5;
		this.cursorEllipse.y = -this.cursorEllipse.height * 0.5;
	}

	private function getIcon():Bitmap {
		return switch (this.mode){
			case MODE_SCALE: this.cursorScale;
			case MODE_ROTATE: this.cursorRotate;
			case MODE_RECTANGLE: this.cursorRectangle;
			case MODE_ELLIPSE: this.cursorEllipse;
			default: null;
		}
	}
}