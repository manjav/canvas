package ir.grantech.canvas.drawables;

import openfl.display.PixelSnapping;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

class CanBitmap extends Bitmap implements ICanItem {
  public var id(default, null):Int;
  public function new() {
    super(null);
  }
}