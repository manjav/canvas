package ir.grantech.canvas.controls.items;

import ir.grantech.canvas.themes.ScaledBitmap;
import feathers.controls.ButtonGroup;
import feathers.controls.IToggle;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.layout.RelativePosition;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;

class ButtonGroupRenderer extends ItemRenderer implements IToggle {
	static public final SIZE:Int = CanTheme.DPI * 9;

	public var index:Int;
	public var skin:Shape;
	public var owner:ButtonGroup;

	public function new() {
		super();
		this.width = this.height = SIZE;
	}

	override private function initializeItemRendererTheme():Void {}

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
		this.icon = new ScaledBitmap(value);
		this.selectedIcon = new ScaledBitmap(value + "-blue");

		return value;
	}

	override private function layoutContent():Void {
		this.icon.x = (this.actualWidth - this.icon.width) * 0.5;
		this.icon.y = (this.actualHeight - this.icon.height) * 0.5;

		this.selectedIcon.width = this.selectedIcon.height = this.icon.width;
		this.selectedIcon.x = icon.x;
		this.selectedIcon.y = icon.y;
	}
}
