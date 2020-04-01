package ir.grantech.canvas.controls.items;

import feathers.controls.ToggleButton;
import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.events.TriggerEvent;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;

class LayerItemRenderer extends ItemRenderer implements IDataRenderer {
	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.layer = cast(this.data, Layer);
		return this.data;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	public function new() {
		super();
		this.height = CanTheme.CONTROL_SIZE;
	}

	override private function initializeItemRendererTheme():Void {}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override function initialize():Void {
		super.initialize();
		var theme = Std.downcast(Theme.getTheme(), CanTheme);
		var skin = new RectangleSkin();
		skin.fill = theme.getContainerFill();
		skin.selectedFill = SolidColor(theme.dividerColor);
		skin.setFillForState(ToggleButtonState.HOVER(false), SolidColor(theme.dividerColor, 0.2));
		this.backgroundSkin = skin;

		this.selectedTextFormat = this.textFormat;
		this.setTextFormatForState(ToggleButtonState.DOWN(false), this.textFormat);
		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
	}

	override private function basicToggleButton_triggerHandler(event:TriggerEvent):Void {
		super.basicToggleButton_triggerHandler(event);
	}
}
