package ir.grantech.canvas.controls.groups;

import openfl.utils.Assets;
import openfl.display.Bitmap;
import feathers.controls.Button;
import ir.grantech.canvas.themes.CanTheme;
import feathers.style.Theme;
import feathers.skins.RectangleSkin;

class Bar extends VGroup {
  
  public function new() {
    super();
  }
  
  @:access(feathers.themes.steel.CanTheme)
  override private function initialize() {
    super.initialize();
    Std.downcast(Theme.getTheme(), CanTheme).setBarStyles(this);

    var button = new Button();
    button.width = width;
    // button.height = width;
    button.icon = new Bitmap(Assets.getBitmapData("pen"));
    addChild(button);
  }
}