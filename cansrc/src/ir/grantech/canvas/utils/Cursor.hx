package ir.grantech.canvas.utils;

import openfl.utils.Assets;
import openfl.display.Bitmap;
import openfl.ui.Mouse;
import flash.display.Sprite;


class Cursor extends Sprite {
	static public final MODE_NONE:Int = -1;
	static public final MODE_SCALE:Int = 0;
	static public final MODE_ROTATE:Int = 1;

	private var cursorScale:Bitmap;
	private var cursorRotate:Bitmap;

	public var mode(default, set):Int;

	private function set_mode(value:Int):Int {
		if (this.mode == value)
			return this.mode;
		this.mode = value;
		this.removeChildren();
		if (this.mode > MODE_NONE) {
			this.addChild(this.mode == MODE_SCALE ? this.cursorScale : this.cursorRotate);
			Mouse.hide();
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