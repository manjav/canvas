package ir.grantech.canvas.utils;

import flash.display.Sprite;
import ir.grantech.canvas.services.Libs.LibItem;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Draggable extends Sprite {
	public var item:LibItem;
	private var bitmap:Bitmap;

	public function new(item:LibItem) {
        super();
		this.item = item;
        this.bitmap = new Bitmap(cast(item.source, BitmapData));
        addChild(this.bitmap);
        this.alpha = 0.5;
	}
}
