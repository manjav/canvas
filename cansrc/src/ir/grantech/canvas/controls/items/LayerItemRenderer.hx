package ir.grantech.canvas.controls.items;

import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.core.InvalidationFlag;
import feathers.events.TriggerEvent;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.services.Layers.Layer;
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
	private var lockDisplay:Bitmap;
	private var hideDisplay:Bitmap;

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

		this.icon = new Bitmap(Assets.getBitmapData("bitmap"));

		this.lockDisplay = new Bitmap(Assets.getBitmapData("lock"));
		this.addChild(this.lockDisplay);

		this.hideDisplay = new Bitmap(Assets.getBitmapData("hide"));
		this.addChild(this.hideDisplay);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.STATE)) {
			if (this.currentState.equals(ToggleButtonState.HOVER(false))) {
				this.hideDisplay.alpha = this.layer.visible ? 0.4 : 1.0;
				this.lockDisplay.alpha = this.layer.enabled ? 0.4 : 1.0;
			} else {
				this.textField.alpha = this.icon.alpha = this.layer.visible ? 1.0 : 0.4;
				this.hideDisplay.alpha = this.layer.visible ? 0.0 : 1.0;
				this.lockDisplay.alpha = this.layer.enabled ? 0.0 : 1.0;
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
				this.layer.enabled = !this.layer.enabled;
			else
				this.layer.visible = !this.layer.visible;
			this.setInvalid(InvalidationFlag.STATE);
			return;
		}
		super.basicToggleButton_triggerHandler(event);
	}
}
