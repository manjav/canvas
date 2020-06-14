package ir.grantech.canvas.controls.items;

import openfl.display.Bitmap;
import ir.grantech.canvas.services.Libs.LibType;
import openfl.text.TextFieldAutoSize;
import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.services.Libs.LibItem;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;
import openfl.text.TextField;

class LibItemRenderer extends ItemRenderer implements IDataRenderer {
	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.item = cast(this.data, LibItem);
		return this.data;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	private var item:LibItem;
	private var typeField:TextField;

	public function new() {
		super();
		this.height = CanTheme.CONTROL_SIZE + CanTheme.DPI * 8;
	}

	override private function initializeItemRendererTheme():Void {}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override function initialize():Void {
		super.initialize();
		var theme = Std.downcast(Theme.getTheme(), CanTheme);
		var skin = new RectangleSkin();
		skin.fill = SolidColor(theme.controlFillColor1);
		skin.selectedFill = SolidColor(theme.dividerColor);
		skin.setFillForState(ToggleButtonState.HOVER(false), SolidColor(theme.dividerColor, 0.2));
		this.backgroundSkin = skin;
		this.paddingLeft = 2 * CanTheme.DPI;

		this.selectedTextFormat = this.textFormat;
		this.setTextFormatForState(ToggleButtonState.DOWN(false), this.textFormat);

		this.icon = this.item.type == LibType.Image ? new Bitmap(this.item.source) : new ScaledBitmap("bitmap");
		var pw = this.icon.width;
		var ph = this.icon.height;
		if (pw > ph) {
			this.icon.width = this.actualHeight - this.paddingLeft * 2;
			this.icon.height = ph * this.icon.width / pw;
		} else {
			this.icon.height = this.actualHeight - this.paddingLeft * 2;
			this.icon.width = pw * this.icon.height / ph;
		}

		this.typeField = new TextField();
		this.typeField.autoSize = TextFieldAutoSize.RIGHT;
		this.addChild(this.typeField);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
	}

	override private function refreshText():Void {
		super.refreshText();
		this.typeField.text = Std.string(this.item.type);
	}

	override private function layoutContent():Void {
		this.icon.x = this.paddingLeft + (this.actualHeight - this.icon.width) * 0.5;
		this.icon.y = (this.actualHeight - this.icon.height) * 0.5;

		this.textField.x = this.actualHeight;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		this.typeField.x = this.actualWidth - this.typeField.width - this.paddingRight;
		this.typeField.y = (this.actualHeight - this.textField.height) * 0.5;
	}
}
