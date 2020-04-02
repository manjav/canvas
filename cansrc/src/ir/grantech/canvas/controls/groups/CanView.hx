package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.core.FeathersControl;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.services.AssetsService;
import ir.grantech.services.CommandsService;
import ir.grantech.services.InputService;

class CanView extends LayoutGroup {
	public var padding(default, set):Float = CanTheme.DEFAULT_PADDING;

	private function set_padding(value:Float):Float {
		if (this.padding == value)
			return this.padding;

		if (this.layout == null)
			return this.padding;
		if (Std.is(this.layout, VerticalLayout)) {
			var layout = cast(this.layout, VerticalLayout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = value;
		}
		if (Std.is(this.layout, HorizontalLayout)) {
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
		if (Std.is(this.layout, VerticalLayout)) {
			var layout = cast(this.layout, VerticalLayout);
			layout.gap = value;
		}
		if (Std.is(this.layout, HorizontalLayout)) {
			var layout = cast(this.layout, HorizontalLayout);
			layout.gap = value;
		}
		return this.gap = value;
	}

	override private function set_enabled(value:Bool):Bool {
		if (super.enabled == value)
			return super.enabled;

		for (item in this.items)
			if (Std.is(item, FeathersControl))
				cast(item, FeathersControl).enabled = value;
		return super.enabled = value;
	}


	public var inputs(get, null):InputService;

	private function get_inputs():InputService {
		return InputService.instance;
	}

	public var assets(get, null):AssetsService;

	private function get_assets():AssetsService {
		return AssetsService.instance;
	}

	public var commands(get, null):CommandsService;

	private function get_commands():CommandsService {
		return CommandsService.instance;
	}
}
