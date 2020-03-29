package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayout;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;
import openfl.events.FocusEvent;

class TransformPanel extends Panel {
	private var inputX:CanTextInput;
	private var inputY:CanTextInput;
	private var inputW:CanTextInput;
	private var inputH:CanTextInput;

	override private function initialize() {
		this.height = 240 * CanTheme.DPI;
		super.initialize();

		var padding = CanTheme.DPI * 7;
		this.layout = new AnchorLayout();
		this.inputX = this.createInput(padding * 1, null, null, padding * 1, 0);
		this.inputY = this.createInput(padding * 3, null, null, padding * 1, 1);
		this.inputW = this.createInput(padding * 1, null, null, padding * 8, 2);
		this.inputH = this.createInput(padding * 3, null, null, padding * 8, 3);
	}

	override private function textInputs_focusInHandler(event:FocusEvent):Void {
		this.inputService.canZoom.scene.transformHint.setVisible(false, true);
		cast(event.currentTarget, CanTextInput).addEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	override private function textInputs_focusOutHandler(event:FocusEvent):Void {
		this.inputService.canZoom.scene.transformHint.set(this.inputService.selectedItem);
		cast(event.currentTarget, CanTextInput).removeEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	private function textInputs_changeHandler(event:Event):Void {
		if (this.inputService.selectedItem == null)
			return;
		var r = this.inputService.selectedItem.rotation;
		this.inputService.selectedItem.rotation = 0;
		if (event.currentTarget == this.inputX)
			this.inputService.selectedItem.x = this.inputX.value;
		else if (event.currentTarget == this.inputY)
			this.inputService.selectedItem.y = this.inputY.value;
		else if (event.currentTarget == this.inputW)
			this.inputService.selectedItem.width = this.inputW.value;
		else if (event.currentTarget == this.inputH)
			this.inputService.selectedItem.height = this.inputH.value;
		this.inputService.selectedItem.rotation = r;
	}

	override private function set_enabled(value:Bool):Bool {
		if (super.enabled == value)
			return super.enabled;

		if (value)
			this.updateData();
		return super.enabled = value;
	}

	public function updateData():Void {
		if (this.inputService.selectedItem == null)
			return;
		this.inputX.value = this.inputService.selectedItem.x;
		this.inputY.value = this.inputService.selectedItem.y;
		this.inputW.value = this.inputService.selectedItem.width;
		this.inputH.value = this.inputService.selectedItem.height;
	}
}
