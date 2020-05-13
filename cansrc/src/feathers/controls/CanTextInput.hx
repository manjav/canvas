package feathers.controls;

import ir.grantech.canvas.themes.ScaledBitmap;
import openfl.display.DisplayObject;

class CanTextInput extends TextInput {
	private var iconDisplay:DisplayObject;

	/**
		The maximum number of characters that the text input can contain, as
		entered by a user. A script can insert more text than
		`maxChars` allows; the `maxChars` property indicates
		only how much text a user can enter. If the value of this property is
		`0`, a user can enter an unlimited amount of text.

		@default 0
	**/
	public var maxChars(default, set):UInt = 0;

	private function set_maxChars(value:UInt):UInt {
		if (this.maxChars == value)
			return value;
		if (this.textField != null)
			this.textField.maxChars = value;
		this.maxChars = value;
		return value;
	}

	/**
		The icon side of text.
	**/
	@:isVar
	public var icon(default, set):String;

	private function set_icon(icon:String):String {
		if (this.icon == icon)
			return this.icon;
		this.createIcon(icon);
		return this.icon = icon;
	}

	private function createIcon(icon:String):Void {
		if (icon == null) {
			if (this.iconDisplay != null)
				this.removeChild(this.iconDisplay);
			return;
		}
		this.iconDisplay = new ScaledBitmap(icon);
		this.addChild(this.iconDisplay);
	}

	override private function set_enabled(value:Bool):Bool {
		if (super.enabled == value)
			return super.enabled;
		if (this.textField != null)
			this.textField.mouseEnabled = value;
		if (this.iconDisplay != null)
			this.iconDisplay.alpha = value ? 1 : 0.6;
		return super.enabled = value;
	}

	public function new() {
		super();
	}

	override private function initialize():Void {
		super.initialize();
		this.textField.maxChars = this.maxChars;
		this.textField.embedFonts = true;
	}

	override private function layoutContent():Void {
		super.layoutContent();
		if (iconDisplay == null)
			return;
		trace(iconDisplay.loaderInfo.content);
		// this.iconDisplay.width = this.iconDisplay.height = this.actualHeight - this.paddingTop - this.paddingBottom - CanTheme.DPI;
		this.iconDisplay.x = this.paddingLeft;
		this.iconDisplay.y = (this.actualHeight - this.iconDisplay.height) * 0.5;
	}
}
