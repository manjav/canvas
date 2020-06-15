package ir.grantech.canvas.controls.items;

import feathers.events.TriggerEvent;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;

class ToolBarItemRenderer extends CanItemRenderer {
	static public var SIZE:Float = 52;

	public function new() {
		super();
		this.height = this.width = SIZE;
	}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override function initialize():Void {
		super.initialize();

		var theme = Std.downcast(Theme.getTheme(), CanTheme);
		var skin = new RectangleSkin();
		skin.fill = SolidColor(theme.controlFillColor1);
		this.backgroundSkin = skin;

		this.iconPosition = MANUAL;
	}

	override private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return value;
		if (value == null)
			return value;
		super.set_data(value);

		var icon = new ScaledBitmap(value);
		icon.width = icon.height = SIZE * 0.5;
		icon.x = (this.width - icon.width) * 0.5;
		icon.y = (this.height - icon.height) * 0.5;
		this.icon = icon;

		var selectedIcon = new ScaledBitmap(value + "-blue");
		selectedIcon.width = selectedIcon.height = icon.width;
		selectedIcon.x = icon.x;
		selectedIcon.y = icon.y;
		this.selectedIcon = selectedIcon;

		return value;
	}

	override private function refreshText():Void {}

	override private function basicToggleButton_triggerHandler(event:TriggerEvent):Void {
		CanEvent.dispatch(this, CanEvent.ITEM_SELECT, this.data, true);
		super.basicToggleButton_triggerHandler(event);
	}
}
