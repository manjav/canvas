package ir.grantech.canvas.controls.items;

import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.core.InvalidationFlag;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;

class MenuItemRenderer extends ItemRenderer implements IDataRenderer {
	@:isVar
	public var data(get, set):Dynamic;

	@:access(Xml)
	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.menuData = cast(this.data, Xml);
		if (this.menuData.children.length == 0)
			this.shortKey = this.menuData.attributeMap["shortKey"];
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	private var menuData:Xml;
	private var shortKey:String;
	// private var layer:Layer;
	private var lockDisplay:ScaledBitmap;
	private var hideDisplay:ScaledBitmap;

	public function new() {
		super();
		this.height = Math.round(CanTheme.CONTROL_SIZE * 1.4);
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

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			if (this.shortKey == null) {
				this.icon = new ScaledBitmap("chevron-r");
			}
		}

		super.update();
	}

	override private function layoutContent():Void {
		this.refreshTextFieldDimensions(false);

		this.textField.x = this.paddingLeft;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		if (this.shortKey == null) {
			this.icon.x = this.actualWidth - this.paddingRight - this.icon.width;
			this.icon.y = (this.actualHeight - this.icon.height) * 0.5;
		} else {
	}
	}
}
