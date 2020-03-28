package ir.grantech.canvas.controls.groups;

import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalLayout;

class VGroup extends CanView {
	public var padding(default, set):Float = 0.0;

	private function set_padding(value:Float):Float {
		if (this.padding == value)
			return this.padding;

		if (this.layout == null)
			return this.padding;
		var layout = cast(this.layout, VerticalLayout);
		layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = value;
		return this.padding = value;
	}

	public var gap(default, set):Float = 0.0;

	private function set_gap(value:Float):Float {
		if (this.gap == value)
			return this.gap;

		if (this.layout == null)
			return this.gap;
		var layout = cast(this.layout, VerticalLayout);
		layout.gap = value;
		return this.gap = value;
	}

	override private function initialize():Void {
		super.initialize();

		var layout = new VerticalLayout();
		layout.horizontalAlign = HorizontalAlign.JUSTIFY;
		layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = padding;
		this.layout = layout;
	}
}
