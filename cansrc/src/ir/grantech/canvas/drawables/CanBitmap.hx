package ir.grantech.canvas.drawables;

import ir.grantech.services.LayersService.Layer;
import openfl.display.Bitmap;

class CanBitmap extends Bitmap implements ICanItem {
  public var layer(default, default):Layer;
  public function new() {
    super(null);
  }
}