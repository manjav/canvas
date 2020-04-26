package ir.grantech.canvas.controls.items;

import feathers.controls.ButtonGroup;
import openfl.display.Shape;
import feathers.controls.IToggle;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.layout.RelativePosition;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Bitmap;

class ButtonGroupRenderer extends ItemRenderer implements IToggle {
	static final SIZE:Int = CanTheme.DPI * 6;
	public var index:Int;
	public var skin:Shape;
	public var owner:ButtonGroup;

	public function new() {
		super();
	}

	override private function initializeItemRendererTheme():Void {}

	override function initialize():Void {
		super.initialize();
	}

	public function draw():Void {

		if (this.skin == null) {
			backgroundSkin = new Shape();
			this.skin = new Shape();
		}

		var left = this.index == 0 ? CanTheme.DPI * 1.5 : 0;
		var right = this.index >= this.owner.dataProvider.length - 1 ? CanTheme.DPI * 1.5 : 0;

		this.skin.graphics.clear();
		this.skin.graphics.beginFill(0xFFFFFF);
		this.skin.graphics.lineStyle(CanTheme.DPI * 0.5, 0xDFDFDF);
		if (this.index == 0 || this.index >= this.owner.dataProvider.length - 1)
			this.skin.graphics.drawRoundRectComplex(0, 0, this.width, this.height, left, right, left, right);
		else
			this.skin.graphics.drawRect(0, 0, this.width, this.height);
		this.skin.graphics.endFill();
		this.addChildAt(this.skin, 0);
	}

	override private function set_text(value:String):String {
		if (this.text == value)
			return this.text;
		this.text = value;
		if (value == null)
			return value;

		this.iconPosition = RelativePosition.MANUAL;
		this.width = this.height = Math.round(CanTheme.DPI * 3.9) * 4;
		var icon = new Bitmap(Assets.getBitmapData(value));
		icon.smoothing = true;
		icon.width = icon.height = this.width * 0.5;
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
