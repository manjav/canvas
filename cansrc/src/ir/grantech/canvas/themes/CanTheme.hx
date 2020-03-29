package ir.grantech.canvas.themes;

import feathers.controls.Application;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.controls.TextInput;
import feathers.controls.TextInputState;
import feathers.skins.RectangleSkin;
import feathers.skins.UnderlineSkin;
import feathers.themes.steel.BaseSteelTheme;
import ir.grantech.canvas.controls.groups.Panel;
import openfl.system.Capabilities;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class CanTheme extends BaseSteelTheme {
	// public static final VARIANT_INPUT_DISPLAY_LABEL = "canvas-theme-input-display-label";
	// public static final VARIANT_OPERATION_BUTTON = "canvas-theme-operation-button";
	static public var DPI:Int = 3;
	static public var DEFAULT_PADDING = 3;
	static public var CONTROL_SIZE = 32;

	public function new() {
		super();
		DPI = Math.round(Capabilities.screenResolutionY / 500);
		DEFAULT_PADDING = DPI;
		CONTROL_SIZE = DPI * 10;
		this.fontSize = DPI * 6;
		// this is a dark theme, set set the default theme to dark mode
		// cast(Theme.fallbackTheme, IDarkModeTheme).darkMode = true;

		this.styleProvider.setStyleFunction(Application, null, setApplicationStyles);
		this.styleProvider.setStyleFunction(TextInput, null, setTextInputStyles);
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);
		this.styleProvider.setStyleFunction(Panel, null, setPanelStyles);
		// this.styleProvider.setStyleFunction(Button, VARIANT_OPERATION_BUTTON, setOperationButtonStyles);
		// this.styleProvider.setStyleFunction(Label, VARIANT_INPUT_DISPLAY_LABEL, setInputDisplayLabelStyles);
	}

	// private var fontName = "_sans";
	// private var fontSize = 50;
	// private var textColor = 0xf1f1f1;
	private var activeColor = 0xff9500;
	private var controlColor = 0xf5f5f5;
	private var operationColor = 0xff9500;

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

	public function setPanelStyles(bar:LayoutGroup):Void {
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

		button.paddingTop = DEFAULT_PADDING;
		button.paddingRight = DEFAULT_PADDING;
		button.paddingBottom = DEFAULT_PADDING;
		button.paddingLeft = DEFAULT_PADDING;
		button.gap = DEFAULT_PADDING;
	}

	private function setTextInputStyles(input:TextInput):Void {
		if (input.backgroundSkin == null) {
			var inputSkin = new UnderlineSkin();
			// inputSkin.cornerRadius = 6.0;
			inputSkin.width = 160.0;
			inputSkin.fill = SolidColor(this.insetFillColor, 0);
			inputSkin.border = getInsetBorder();
			inputSkin.setBorderForState(TextInputState.FOCUSED, getThemeBorder());
			input.backgroundSkin = inputSkin;
		}

		if (input.textFormat == null)
			input.textFormat = getTextFormat();
		
		if (input.getTextFormatForState(TextInputState.DISABLED) == null)
			input.setTextFormatForState(TextInputState.DISABLED, getDisabledTextFormat());
		
		input.paddingTop = 6.0;
		input.paddingRight = 10.0;
		input.paddingBottom = 6.0;
		input.paddingLeft = 10.0;
	}
}
