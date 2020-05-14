package ir.grantech.canvas.controls.items;

import ir.grantech.canvas.themes.ScaledBitmap;
import ir.grantech.canvas.services.Commands.*;
import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.core.InvalidationFlag;
import feathers.events.TriggerEvent;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Layers.Layer;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Bitmap;

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

	private var layer:Layer;
	private var lockDisplay:ScaledBitmap;
	private var hideDisplay:ScaledBitmap;

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

		this.icon = new ScaledBitmap("bitmap");

		this.lockDisplay = new ScaledBitmap("lock");
		this.addChild(this.lockDisplay);

		this.hideDisplay = new ScaledBitmap("hide");
		this.addChild(this.hideDisplay);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.STATE)) {
			if (this.currentState.equals(ToggleButtonState.HOVER(false))) {
				this.hideDisplay.alpha = this.layer.getBool(VISIBLE) ? 0.4 : 1.0;
				this.lockDisplay.alpha = this.layer.getBool(ENABLE) ? 0.4 : 1.0;
			} else {
				this.textField.alpha = this.icon.alpha = this.layer.getBool(VISIBLE) ? 1.0 : 0.4;
				this.hideDisplay.alpha = this.layer.getBool(VISIBLE) ? 0.0 : 1.0;
				this.lockDisplay.alpha = this.layer.getBool(ENABLE) ? 0.0 : 1.0;
			}
		}

		super.update();
	}

	override private function layoutContent():Void {
		this.icon.x = this.paddingLeft;
		this.icon.y = (this.actualHeight - this.icon.height) * 0.5;

		this.textField.x = this.paddingLeft + this.icon.width + this.gap;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		this.hideDisplay.x = this.actualWidth - this.paddingRight - this.hideDisplay.width;
		this.hideDisplay.y = (this.actualHeight - this.hideDisplay.height) * 0.5;

		this.lockDisplay.x = this.actualWidth - this.paddingRight - this.hideDisplay.width - this.gap * 2 - this.lockDisplay.width;
		this.lockDisplay.y = (this.actualHeight - this.lockDisplay.height) * 0.5;
	}

	override private function basicToggleButton_triggerHandler(event:TriggerEvent):Void {
		if (this.mouseX > this.lockDisplay.x) {
			if (this.mouseX < this.lockDisplay.x + this.lockDisplay.width)
				this.layer.setProperty(ENABLE, !this.layer.getBool(ENABLE));
			else
				this.layer.setProperty(VISIBLE, !this.layer.getBool(VISIBLE));
			this.setInvalid(InvalidationFlag.STATE);
			return;
		} else {
			CanEvent.dispatch(this, CanEvent.ITEM_SELECT, this.data, true);
		}
		super.basicToggleButton_triggerHandler(event);
	}
}
