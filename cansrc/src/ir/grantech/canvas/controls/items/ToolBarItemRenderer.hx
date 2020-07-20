package ir.grantech.canvas.controls.items;

import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.events.TriggerEvent;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;

class ToolBarItemRenderer extends ItemRenderer implements IDataRenderer {
	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.icon = new ScaledBitmap(value);
		this.selectedIcon = new ScaledBitmap(value + "-blue");
		return value;
	}

	private function get_data():Dynamic {
		return this.data;
	}

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

	override private function initializeItemRendererTheme():Void {}

	override private function refreshText():Void {}

	override private function basicToggleButton_triggerHandler(event:TriggerEvent):Void {
		CanEvent.dispatch(this, CanEvent.ITEM_SELECT, this.data, true);
		super.basicToggleButton_triggerHandler(event);
	}

	override private function layoutContent():Void {
		icon.x = (SIZE - icon.width) * 0.5;
		icon.y = (SIZE - icon.height) * 0.5;
		selectedIcon.x = (SIZE - selectedIcon.width) * 0.5;
		selectedIcon.y = (SIZE - selectedIcon.height) * 0.5;
	}
}
