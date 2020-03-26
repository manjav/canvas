package ir.grantech.canvas.controls.groups.bars;

import ir.grantech.canvas.themes.CanTheme;
import feathers.style.Theme;

class Bar extends VGroup {
  
  @:access(feathers.themes.steel.CanTheme)
  override private function initialize() {
    super.initialize();
    Std.downcast(Theme.getTheme(), CanTheme).setBarStyles(this);
    this.padding = CanTheme.DEFAULT_PADDING;
  }
}