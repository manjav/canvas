package ir.grantech.canvas.drawables;

import ir.grantech.services.LayersService.Layer;
import openfl.display.Sprite;

class CanSprite extends Sprite implements ICanItem {
  public var layer(default, default):Layer;
}