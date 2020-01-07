package ir.grantech.canvas.themes;

import feathers.controls.Application;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.skins.RectangleSkin;
import feathers.themes.steel.BaseSteelTheme;
import ir.grantech.canvas.controls.groups.Bar;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class CanTheme extends BaseSteelTheme {

	// public static final VARIANT_INPUT_DISPLAY_LABEL = "canvas-theme-input-display-label";
	// public static final VARIANT_OPERATION_BUTTON = "canvas-theme-operation-button";
	static public final DEFAULT_PADDING = 5;
	public function new() {
		super();
		// this is a dark theme, set set the default theme to dark mode
		// cast(Theme.fallbackTheme, IDarkModeTheme).darkMode = true;

		this.styleProvider.setStyleFunction(Application, null, setApplicationStyles);
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);
		this.styleProvider.setStyleFunction(Bar, null, setBarStyles);
		// this.styleProvider.setStyleFunction(Button, VARIANT_OPERATION_BUTTON, setOperationButtonStyles);
		// this.styleProvider.setStyleFunction(Label, VARIANT_INPUT_DISPLAY_LABEL, setInputDisplayLabelStyles);
	}

	// private var fontName = "_sans";
	// private var fontSize = 50;
	// private var textColor = 0xf1f1f1;
	private var activeColor = 0xff9500;
	private var controlColor = 0xf5f5f5;
	private var operationColor = 0xff9500;
	private var padding = 6.0;

	private function getInputDisplayLabelTextFormat():TextFormat {
		var result = this.getTextFormat();
		result.align = TextFormatAlign.RIGHT;
		return result;
	}

	private function setApplicationStyles(app:Application):Void {
		if (app.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(app.stage.color);
			app.backgroundSkin = skin;
		}
	}

	public function setBarStyles(bar:LayoutGroup):Void {
		if (bar.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(this.controlColor);
			bar.backgroundSkin = skin;
		}
	}
	private function setButtonStyles(button:Button):Void {
		if (button.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(this.controlColor, 0);
			button.backgroundSkin = skin;
		}
		// if (button.getSkinForState(ButtonState.DOWN) == null) {
		// 	var skin = new RectangleSkin();
		// 	skin.fill = SolidColor(this.activeColor);
		// 	button.setSkinForState(ButtonState.DOWN, skin);
		// }

		if (button.textFormat == null)
			button.textFormat = this.getTextFormat();

		button.paddingTop = this.padding;
		button.paddingRight = this.padding;
		button.paddingBottom = this.padding;
		button.paddingLeft = this.padding;
		button.gap = this.padding;
	}
}
