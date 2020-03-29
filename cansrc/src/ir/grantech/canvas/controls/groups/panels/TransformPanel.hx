package ir.grantech.canvas.controls.groups.panels;

import feathers.layout.AnchorLayoutData;
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
	private var inputR:CanTextInput;

	override private function initialize() {
		this.height = 240 * CanTheme.DPI;
		super.initialize();

		var padding = CanTheme.DPI * 7;
		this.layout = new AnchorLayout();
		this.inputX = this.createInput("x", new AnchorLayoutData(padding * 1, null, null, padding));
		this.inputY = this.createInput("y", new AnchorLayoutData(padding * 5, null, null, padding));
		this.inputW = this.createInput("w", new AnchorLayoutData(padding * 1, null, null, null, 0));
		this.inputH = this.createInput("h", new AnchorLayoutData(padding * 5, null, null, null, 0));
		this.inputR = this.createInput("rotate", new AnchorLayoutData(padding * 1, padding));
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
		if (event.currentTarget != this.inputR)
		this.inputService.selectedItem.rotation = 0;
		if (event.currentTarget == this.inputX)
			this.inputService.selectedItem.x = this.inputX.value;
		else if (event.currentTarget == this.inputY)
			this.inputService.selectedItem.y = this.inputY.value;
		else if (event.currentTarget == this.inputW)
			this.inputService.selectedItem.width = this.inputW.value;
		else if (event.currentTarget == this.inputH)
			this.inputService.selectedItem.height = this.inputH.value;
		else if (event.currentTarget == this.inputR)
			this.inputService.canZoom.scene.transformHint.rotate(this.inputR.value / 180 * Math.PI);
		if (event.currentTarget != this.inputR)
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
		this.inputR.value = this.inputService.selectedItem.rotation;
	}
}
