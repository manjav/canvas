package ir.grantech.canvas.controls.groups;

import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.controls.LayoutGroup;
import ir.grantech.services.InputService;

class CanView extends LayoutGroup {
	public var padding(default, set):Float = 0.0;

	private function set_padding(value:Float):Float {
		if (this.padding == value)
			return this.padding;

		if (this.layout == null)
			return this.padding;
		if( Std.is(this.layout, VerticalLayout) ){
			var layout = cast(this.layout, VerticalLayout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = value;
		}
		if( Std.is(this.layout, HorizontalLayout) ){
			var layout = cast(this.layout, HorizontalLayout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = value;
		}
		return this.padding = value;
	}

	public var gap(default, set):Float = 0.0;

	private function set_gap(value:Float):Float {
		if (this.gap == value)
			return this.gap;

		if (this.layout == null)
			return this.gap;
		if( Std.is(this.layout, VerticalLayout) ){
			var layout = cast(this.layout, VerticalLayout);
			layout.gap = value;
		}
		if( Std.is(this.layout, HorizontalLayout) ){
			var layout = cast(this.layout, HorizontalLayout);
			layout.gap	 = value;
		}
		return this.gap = value;
	}

	public var input(get, null):InputService;

	private function get_input():InputService {
		return InputService.instance;
	}
}