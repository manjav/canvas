package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.Bitmap;
import openfl.utils.Assets;

class Bar extends VGroup {
  
  public function new() {
    super();
  }
  
  @:access(feathers.themes.steel.CanTheme)
  override private function initialize() {
    super.initialize();
    Std.downcast(Theme.getTheme(), CanTheme).setBarStyles(this);

    this.padding = 5;
    var button = new Button();
    button.height = width - padding * 2;
    button.icon = new Bitmap(Assets.getBitmapData("pen"));
    addChild(button);
  }
}