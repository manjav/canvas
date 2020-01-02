package ir.grantech.canvas.controls.groups;

import feathers.layout.HorizontalAlign;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;

class VGroup extends LayoutGroup {
  override private function initialize() {
    super.initialize();

    var layout = new VerticalLayout();
    layout.horizontalAlign = HorizontalAlign.JUSTIFY;
    this.layout = layout;
  }
}