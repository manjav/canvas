package ir.grantech.canvas.controls.items;

import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import ir.grantech.canvas.themes.CanTheme;

class CanItemRenderer extends ItemRenderer implements IDataRenderer {
	public static final VARIANT_SOLID = "solid";
	public static final VARIANT_UNDERLINE = "underline";

	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return value;
		if (value == null)
			return value;
		this.data = value;
		return value;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	public function new() {
		super();
		this.height = CanTheme.CONTROL_SIZE + CanTheme.DPI * 8;
	}

	override private function initializeItemRendererTheme():Void {}
}
