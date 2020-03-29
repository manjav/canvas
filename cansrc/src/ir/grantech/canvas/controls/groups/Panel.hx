package ir.grantech.canvas.controls.groups;

import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.FocusEvent;

class Panel extends CanView {
	@:access(feathers.themes.steel.CanTheme)
	override private function initialize() {
		super.initialize();
		Std.downcast(Theme.getTheme(), CanTheme).setPanelStyles(this);
		this.padding = CanTheme.DEFAULT_PADDING;
	}

	private function createInput(?top:Null<Float>, ?right:Null<Float>, ?bottom:Null<Float>, ?left:Null<Float>, tabIndex:Int):CanTextInput {
		var element = new CanTextInput();
		element.width = 32 * CanTheme.DPI;
		element.height = 16 * CanTheme.DPI;
		element.step = 2;
		element.layoutData = new AnchorLayoutData(top, right, bottom, left);
		element.addEventListener(FocusEvent.FOCUS_IN, this.textInputs_focusInHandler);
		element.addEventListener(FocusEvent.FOCUS_OUT, this.textInputs_focusOutHandler);
		this.addChild(element);
		return element;
	}

	private function textInputs_focusInHandler(event:FocusEvent):Void {}
	private function textInputs_focusOutHandler(event:FocusEvent):Void {}
}
