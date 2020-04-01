package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.themes.CanTheme;
import feathers.controls.LayoutGroup;
import feathers.core.FeathersControl;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import ir.grantech.services.InputService;
import ir.grantech.services.LayersService;

class CanView extends LayoutGroup {
	public var padding(default, set):Float = CanTheme.DEFAULT_PADDING;

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

	public var gap(default, set):Float = CanTheme.DEFAULT_PADDING;

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

	public var inputService(get, null):InputService;

	private function get_inputService():InputService {
		return InputService.instance;
	}

	public var layersService(get, null):LayersService;

	private function get_layersService():LayersService {
		return LayersService.instance;
	}
}
