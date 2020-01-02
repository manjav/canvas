package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalAlign;
class HGroup extends LayoutGroup {
  override private function initialize() {
    super.initialize();

    var layout = new HorizontalLayout();
    layout.verticalAlign = VerticalAlign.JUSTIFY;
    this.layout = layout;
  }
}