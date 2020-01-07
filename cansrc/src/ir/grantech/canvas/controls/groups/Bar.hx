package ir.grantech.canvas.controls.groups;

import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;

class Bar extends VGroup {
  
  @:access(feathers.themes.steel.CanTheme)
  override private function initialize() {
    super.initialize();
    Std.downcast(Theme.getTheme(), CanTheme).setBarStyles(this);
    this.padding = CanTheme.DEFAULT_PADDING;
  }
}