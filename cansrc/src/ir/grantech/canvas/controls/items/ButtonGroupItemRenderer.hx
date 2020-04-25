package ir.grantech.canvas.controls.items;

import openfl.Assets;
import openfl.display.Bitmap;
import feathers.skins.RectangleSkin;
import ir.grantech.canvas.themes.CanTheme;
import feathers.style.Theme;
import feathers.controls.IToggle;
import feathers.controls.dataRenderers.ItemRenderer;

class ButtonGroupItemRenderer extends ItemRenderer implements IToggle {
	public function new() {
		super();
	}

	override private function initializeItemRendererTheme():Void {}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override function initialize():Void {
		super.initialize();
		var theme = Std.downcast(Theme.getTheme(), CanTheme);
		var skin = new RectangleSkin();
		skin.fill = theme.getContainerFill();
		skin.border = SolidColor(2);
		this.backgroundSkin = skin;
		this.width = this.height = CanTheme.CONTROL_SIZE;
	}

	override private function set_text(value:String):String {
		if (this.text == value)
			return this.text;
		this.text = value;
		if (value == null)
			return value;

		var icon = new Bitmap(Assets.getBitmapData(value));
		icon.smoothing = true;
		icon.width = icon.height = CanTheme.CONTROL_SIZE * 0.5;
		icon.x = (this.width - icon.width) * 0.5;
		icon.y = (this.height - icon.height) * 0.5;
		this.icon = icon;

		var selectedIcon = new Bitmap(Assets.getBitmapData(value + "-selected"));
		selectedIcon.smoothing = true;
		selectedIcon.width = selectedIcon.height = icon.width;
		selectedIcon.x = icon.x;
		selectedIcon.y = icon.y;
		this.selectedIcon = selectedIcon;

		return value;
	}
}
