package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.CanRangeInput;
import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

class Panel extends CanView {
	@:access(feathers.themes.steel.CanTheme)
	override private function initialize() {
		super.initialize();
		Std.downcast(Theme.getTheme(), CanTheme).setPanelStyles(this);
		this.padding = CanTheme.DEFAULT_PADDING;
	}

	private function createButton(icon:String, layoutData:AnchorLayoutData):Button {
		var disabledIcon = new Bitmap(Assets.getBitmapData(icon));
		disabledIcon.alpha = 0.6;
		var element = new Button();
		element.width = element.height = 16 * CanTheme.DPI;
		element.icon = new Bitmap(Assets.getBitmapData(icon));
		element.setIconForState(ButtonState.DISABLED, disabledIcon);
		element.layoutData = layoutData;
		element.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.addChild(element);
		return element;
	}

	private function createTextInput(icon:String, layoutData:AnchorLayoutData):CanTextInput {
		var element = new CanTextInput();
		this.redjustInput(element, icon, layoutData);
		return element;
	}

	private function createRangeInput(icon:String, layoutData:AnchorLayoutData):CanRangeInput {
		var element = new CanRangeInput();
		this.redjustInput(element, icon, layoutData);
		element.step = 2;
		return element;
	}

	private function redjustInput(element:CanTextInput, icon:String, layoutData:AnchorLayoutData):Void {
		element.width = 36 * CanTheme.DPI;
		element.height = 16 * CanTheme.DPI;
		element.icon = icon;
		element.layoutData = layoutData;
		element.addEventListener(FocusEvent.FOCUS_IN, this.textInputs_focusInHandler);
		element.addEventListener(FocusEvent.FOCUS_OUT, this.textInputs_focusOutHandler);
		this.addChild(element);
	}

	private function buttons_clickHandler(event:MouseEvent):Void {}

	private function textInputs_focusInHandler(event:FocusEvent):Void {}

	private function textInputs_focusOutHandler(event:FocusEvent):Void {}
}
