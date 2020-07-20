package ir.grantech.canvas.controls.items;

import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.core.InvalidationFlag;
import ir.grantech.canvas.themes.CanTheme;

class PopupListItemRenderer extends ItemRenderer implements IDataRenderer {
	public static final HEIGHT:Int = Math.floor(CanTheme.CONTROL_SIZE * 1.5); 
	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	override private function initializeItemRendererTheme():Void {}

	override function initialize():Void {
		super.initialize();
		this.height = HEIGHT;
		// this.selectedTextFormat = this.textFormat;
		// this.setTextFormatForState(ToggleButtonState.DOWN(false), this.textFormat);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
	}

	override private function layoutContent():Void {
		this.refreshTextFieldDimensions(false);

		this.textField.x = this.paddingLeft;
		this.textField.height = this.actualHeight * 0.5;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		if (this.icon != null) {
			this.icon.x = this.actualWidth - this.paddingRight - this.icon.width;
			this.icon.y = (this.actualHeight - this.icon.height) * 0.5;
		}
	}
}
