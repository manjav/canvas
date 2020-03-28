package ir.grantech.canvas.controls.groups;

import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalLayout;

class VGroup extends CanView {

	override private function initialize():Void {
		super.initialize();

		var layout = new VerticalLayout();
		layout.horizontalAlign = HorizontalAlign.JUSTIFY;
		layout.gap = layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = padding;
		this.layout = layout;
	}
}
