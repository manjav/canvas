package ir.grantech.canvas.drawables;

import ir.grantech.services.LayersService.Layer;
import openfl.display.Shape;

class CanShape extends Shape implements ICanItem {
  public var layer(default, default):Layer;
}