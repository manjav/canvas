package ir.grantech.canvas.drawables;

import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.Shape;

class CanShape extends Shape implements ICanItem {
  public var layer(default, default):Layer;
}