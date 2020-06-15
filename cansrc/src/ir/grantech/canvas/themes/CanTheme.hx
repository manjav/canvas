package ir.grantech.canvas.themes;

import ir.grantech.canvas.controls.items.CanItemRenderer;
import feathers.controls.Application;
import feathers.controls.BasicButton;
import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.CanTextInput;
import feathers.controls.Check;
import feathers.controls.HSlider;
import feathers.controls.Label;
import feathers.controls.PopUpListView;
import feathers.controls.TextInput;
import feathers.controls.TextInputState;
import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.graphics.FillStyle;
import feathers.skins.CircleSkin;
import feathers.skins.RectangleSkin;
import feathers.skins.UnderlineSkin;
import feathers.themes.steel.BaseSteelTheme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.system.Capabilities;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class CanTheme extends BaseSteelTheme {
	// public static final VARIANT_INPUT_DISPLAY_LABEL = "canvas-theme-input-display-label";
	// public static final VARIANT_OPERATION_BUTTON = "canvas-theme-operation-button";
	static public var DPI:Int = 4;
	static public var DEFAULT_PADDING = 4;
	static public var CONTROL_SIZE = 32;
	static public final HINT_COLOR:UInt = 0x1692E6;

	public var headerTextColor:UInt;

	public function new() {
		super();
		DPI = Math.round(Capabilities.screenResolutionY / 500);
		DEFAULT_PADDING = DPI * 8;
		CONTROL_SIZE = DPI * 18;
		trace(Capabilities.screenResolutionY, DPI, DEFAULT_PADDING, CONTROL_SIZE);
		this.fontSize = Math.round(DPI * 5.5);
		this.headerFontSize = DPI * 5;
		this.textColor = this.darkMode ? 0x646464 : 0x464646;
		this.controlFillColor1 = this.darkMode ? 0x5f5f5f : 0xf4f4f4;
		this.headerTextColor = this.disabledTextColor = this.darkMode ? 0xAaAaAa : 0xAaAaAa;
		this.containerFillColor = this.darkMode ? 0x383838 : 0xfdfdfd;
		// this is a dark theme, set set the default theme to dark mode
		// cast(Theme.fallbackTheme, IDarkModeTheme).darkMode = true;

		this.styleProvider.setStyleFunction(Application, null, setApplicationStyles);
		this.styleProvider.setStyleFunction(Label, null, setLabelStyles);
		this.styleProvider.setStyleFunction(Label, Label.VARIANT_DETAIL, setLabelDetailStyles);
		this.styleProvider.setStyleFunction(Label, Label.VARIANT_HEADING, setLabelHeadingStyles);
		this.styleProvider.setStyleFunction(Check, null, setCheckStyles);
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);
		this.styleProvider.setStyleFunction(HSlider, null, setHSliderStyles);
		this.styleProvider.setStyleFunction(TextInput, null, setTextInputStyles);
		this.styleProvider.setStyleFunction(ItemRenderer, null, setItemRendererSolidStyles);
		this.styleProvider.setStyleFunction(ItemRenderer, CanItemRenderer.VARIANT_UNDERLINE, setItemRendererUnderlineStyles);
		this.styleProvider.setStyleFunction(Button, PopUpListView.CHILD_VARIANT_BUTTON, setButtonPopupStyles);

		// this.styleProvider.setStyleFunction(Button, VARIANT_OPERATION_BUTTON, setOperationButtonStyles);
		// this.styleProvider.setStyleFunction(Label, VARIANT_INPUT_DISPLAY_LABEL, setInputDisplayLabelStyles);
	}

	// private var fontName = "_sans";
	// private var fontSize = 50;
	// private var textColor = 0xf1f1f1;
	private var activeColor = 0xff9500;
	// private var controlColor = 0xfafafa;
	private var operationColor = 0xff9500;

	override private function refreshFonts():Void {
		this.fontName = "IRANSans Light";
		this.refreshFontSizes();
	}

	private function getInputDisplayLabelTextFormat():TextFormat {
		var result = this.getTextFormat();
		return result;
	}

	private function setApplicationStyles(app:Application):Void {
		if (app.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(app.stage.color);
			app.backgroundSkin = skin;
		}
	}

	private function setButtonStyles(button:Button):Void {
		if (button.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(this.controlFillColor1, 0);
			button.backgroundSkin = skin;
		}

		if (button.textFormat == null)
			button.textFormat = this.getTextFormat();

		button.paddingTop = DEFAULT_PADDING;
		button.paddingRight = DEFAULT_PADDING;
		button.paddingBottom = DEFAULT_PADDING;
		button.paddingLeft = DEFAULT_PADDING;
		button.gap = DEFAULT_PADDING;
	}

	private function setButtonPopupStyles(button:Button):Void {
		if (button.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.cornerRadius = DPI * 4;
			skin.fill = SolidColor(this.controlFillColor1, 1);
			skin.border = LineStyle.SolidColor(DPI * 0.5, this.disabledTextColor);
			skin.setBorderForState(ButtonState.DISABLED, LineStyle.SolidColor(DPI * 0.5, this.disabledTextColor, 0.5));
			button.backgroundSkin = skin;
		}

		if (button.textFormat == null)
			button.textFormat = this.getTextFormat();

		if (button.getTextFormatForState(ButtonState.DISABLED) == null)
			button.setTextFormatForState(ButtonState.DISABLED, this.getDisabledTextFormat());

		button.paddingRight = DEFAULT_PADDING;
		button.paddingLeft = DEFAULT_PADDING;
		button.gap = Math.POSITIVE_INFINITY;
		button.horizontalAlign = LEFT;
		button.verticalAlign = MIDDLE;
		button.minGap = 6.0;

		button.icon = new ScaledBitmap("chevron-d");

		var bmp = new ScaledBitmap("chevron-d");
		bmp.alpha = 0.5;
		button.setIconForState(ButtonState.DISABLED, bmp);
		button.iconPosition = RIGHT;
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
		input.textFormat.size = this.headerFontSize;
		input.textFormat.align = TextFormatAlign.CENTER;
		if (Std.is(input, CanTextInput))
			input.textFormat.indent = cast(input, CanTextInput).icon != null ? DPI * 8 : 0;

		if (input.getTextFormatForState(TextInputState.DISABLED) == null) {
			var format = getDisabledTextFormat();
			format.size = this.headerFontSize;
			input.setTextFormatForState(TextInputState.DISABLED, format);
		}

		input.paddingTop = 6.0;
		input.paddingRight = 10.0;
		input.paddingBottom = 6.0;
		input.paddingLeft = 10.0;
	}

	private function setLabelStyles(label:Label):Void {
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat();
		if (label.disabledTextFormat == null)
			label.disabledTextFormat = this.getDisabledTextFormat();
	}

	private function setLabelDetailStyles(label:Label):Void {
		if (label.textFormat == null)
			label.textFormat = this.getDetailTextFormat();
		if (label.disabledTextFormat == null)
			label.disabledTextFormat = this.getDisabledDetailTextFormat();
	}

	private function setLabelHeadingStyles(label:Label):Void {
		if (label.textFormat == null)
			label.textFormat = this.getHeaderTextFormat();
		if (label.disabledTextFormat == null)
			label.disabledTextFormat = this.getDisabledHeaderTextFormat();
	}

	private function setHSliderStyles(slider:HSlider):Void {
		if (slider.thumbSkin == null) {
			var thumbSkin = new CircleSkin();
			thumbSkin.border = LineStyle.SolidColor(DPI, this.textColor);
			thumbSkin.setBorderForState(ButtonState.DISABLED, LineStyle.SolidColor(DPI, this.textColor));
			thumbSkin.fill = SolidColor(this.controlFillColor1, 1);
			thumbSkin.setFillForState(ButtonState.DOWN, SolidColor(this.textColor, 1));
			thumbSkin.width = DPI * 8;
			thumbSkin.height = DPI * 8;
			var thumb = new BasicButton();
			thumb.keepDownStateOnRollOut = true;
			thumb.backgroundSkin = thumbSkin;
			slider.thumbSkin = thumb;
		}

		if (slider.trackSkin == null) {
			var trackSkin = new RectangleSkin();
			trackSkin.fill = SolidColor(this.textColor, 1);
			trackSkin.setFillForState(ButtonState.DISABLED, SolidColor(this.disabledTextColor, 1));
			trackSkin.height = DPI;
			slider.trackSkin = trackSkin;
		}

		if (slider.secondaryTrackSkin == null) {
			var secondaryTrackSkin = new RectangleSkin();
			secondaryTrackSkin.fill = SolidColor(this.disabledTextColor, 0.5);
			secondaryTrackSkin.height = DPI;
			slider.secondaryTrackSkin = secondaryTrackSkin;
		}
	}

	private function setItemRendererStyles(itemRenderer:ItemRenderer):Void {
		if (itemRenderer.textFormat == null)
			itemRenderer.textFormat = this.getTextFormat();

		// if (itemRenderer.disabledTextFormat == null)
		// 	itemRenderer.disabledTextFormat = this.getDisabledTextFormat();

		// if (itemRenderer.selectedTextFormat == null)
		// 	itemRenderer.selectedTextFormat = this.getActiveTextFormat();

		// if (itemRenderer.getTextFormatForState(ToggleButtonState.DOWN(false)) == null)
		// 	itemRenderer.setTextFormatForState(ToggleButtonState.DOWN(false), this.getActiveTextFormat());

		itemRenderer.paddingTop = DEFAULT_PADDING;
		itemRenderer.paddingRight = DEFAULT_PADDING;
		itemRenderer.paddingBottom = DEFAULT_PADDING;
		itemRenderer.paddingLeft = DEFAULT_PADDING;
		itemRenderer.horizontalAlign = LEFT;
	}

	private function setItemRendererSolidStyles(itemRenderer:ItemRenderer):Void {
		this.setItemRendererStyles(itemRenderer);
		if (itemRenderer.backgroundSkin == null) {
			var skin = new RectangleSkin();
			skin.fill = SolidColor(this.controlFillColor1);
			skin.selectedFill = SolidColor(this.dividerColor);
			skin.setFillForState(ToggleButtonState.HOVER(false), SolidColor(this.dividerColor, 0.2));
			itemRenderer.backgroundSkin = skin;
		}
	}

	private function setItemRendererUnderlineStyles(itemRenderer:ItemRenderer):Void {
		this.setItemRendererStyles(itemRenderer);
		if (itemRenderer.backgroundSkin == null) {
			var skin = new UnderlineSkin();
			skin.fill = this.getContainerFill();
			skin.border = this.getDividerBorder();
			skin.selectedFill = this.getActiveThemeFill();
			skin.setFillForState(ToggleButtonState.DOWN(false), this.getActiveThemeFill());
			skin.width = CONTROL_SIZE;
			skin.height = CONTROL_SIZE;
			skin.minWidth = CONTROL_SIZE;
			skin.minHeight = CONTROL_SIZE;
			itemRenderer.backgroundSkin = skin;
		}
	}

	private function setCheckStyles(check:Check):Void {
		if (check.textFormat == null)
			check.textFormat = this.getTextFormat();

		if (check.disabledTextFormat == null)
			check.disabledTextFormat = this.getDisabledTextFormat();

		var icon = new RectangleSkin();
		icon.cornerRadius = DPI * 3;
		icon.minHeight = icon.minWidth = icon.height = icon.width = DPI * 8;
		icon.border = SolidColor(DPI, this.textColor);
		icon.fill = this.getControlDisabledFill();
		icon.disabledFill = this.getDisabledInsetFill();
		icon.setFillForState(DOWN(false), SolidColor(0));
		check.icon = icon;

		var selectedIcon = new RectangleSkin();
		selectedIcon.cornerRadius = icon.cornerRadius;
		selectedIcon.minHeight = selectedIcon.minWidth = selectedIcon.height = selectedIcon.width = icon.width;
		selectedIcon.fill = SolidColor(this.textColor);
		selectedIcon.disabledFill = SolidColor(this.disabledTextColor);

		var checkMark = new Shape();
		checkMark.graphics.beginFill(this.controlFillColor1);
		checkMark.graphics.drawRoundRect(-DPI, -DPI * 5.6, DPI, DPI * 5.6, DPI, DPI);
		checkMark.graphics.beginFill(this.controlFillColor1);
		checkMark.graphics.drawRoundRect(-DPI * 3, -DPI, DPI * 3, DPI, DPI, DPI);
		checkMark.graphics.endFill();
		checkMark.rotation = 45.0;
		checkMark.x = DPI * 3.2;
		checkMark.y = DPI * 6.2;
		selectedIcon.addChild(checkMark);

		check.selectedIcon = selectedIcon;
		check.gap = 0;
	}

	override private function getHeaderTextFormat():TextFormat {
		return new TextFormat(this.fontName, this.headerFontSize, this.headerTextColor);
	}

	override private function getActiveThemeFill():FillStyle {
		return SolidColor(this.textColor, 1);
	}

	static public function getBitmap(name:String):Bitmap {
		var bd = Assets.getBitmapData(name);
		var bmp = new Bitmap(bd);
		bmp.width = bd.width / 4 * DPI;
		bmp.height = bd.height / 4 * DPI;
		return bmp;
	}
}
