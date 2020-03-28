package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.themes.CanTheme;
import feathers.style.Theme;

class Panel extends CanView {
  
  @:access(feathers.themes.steel.CanTheme)
  override private function initialize() {
    super.initialize();
    Std.downcast(Theme.getTheme(), CanTheme).setPanelStyles(this);
    this.padding = CanTheme.DEFAULT_PADDING;
  }
}