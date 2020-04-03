package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.Button;
import feathers.controls.CanRangeInput;
import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.services.Commands;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

class TransformPanel extends Panel {
	private var inputX:CanRangeInput;
	private var inputY:CanRangeInput;
	private var inputW:CanRangeInput;
	private var inputH:CanRangeInput;
	private var inputR:CanRangeInput;
	private var buttonFlipH:Button;
	private var buttonFlipV:Button;

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "TRANSFORM";
		
		this.inputX = this.createRangeInput("x", new AnchorLayoutData(padding * 3, null, null, padding));
		this.inputY = this.createRangeInput("y", new AnchorLayoutData(padding * 7, null, null, padding));
		this.inputW = this.createRangeInput("w", new AnchorLayoutData(padding * 3, null, null, null, 0));
		this.inputH = this.createRangeInput("h", new AnchorLayoutData(padding * 7, null, null, null, 0));
		this.inputR = this.createRangeInput("rotate", new AnchorLayoutData(padding * 3, padding));
		
		this.buttonFlipH = this.createButton("flip-h", new AnchorLayoutData(padding * 7, padding * 4));
		this.buttonFlipV = this.createButton("flip-v", new AnchorLayoutData(padding * 7, padding * 1));

		this.height = padding * 11;
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		if (event.currentTarget == this.buttonFlipH)
			this.inputService.canZoom.scene.transformHint.scale(-1, 1);
		else if (event.currentTarget == this.buttonFlipV)
			this.inputService.canZoom.scene.transformHint.scale(1, -1);
	}

	override private function textInputs_focusInHandler(event:FocusEvent):Void {
		this.inputs.canZoom.scene.transformHint.setVisible(false, event.currentTarget != this.inputR);
		cast(event.currentTarget, CanTextInput).addEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	override private function textInputs_focusOutHandler(event:FocusEvent):Void {
		this.inputs.canZoom.scene.transformHint.set(this.inputs.selectedItem);
		cast(event.currentTarget, CanTextInput).removeEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	private function textInputs_changeHandler(event:Event):Void {
		if (this.inputs.selectedItem == null)
			return;
		var r = this.inputs.selectedItem.rotation;
		if (event.currentTarget != this.inputR)
			this.inputs.selectedItem.rotation = 0;
		if (event.currentTarget == this.inputX)
			this.inputs.selectedItem.x = this.inputX.value;
		else if (event.currentTarget == this.inputY)
			this.inputs.selectedItem.y = this.inputY.value;
		else if (event.currentTarget == this.inputW)
			this.inputs.selectedItem.width = this.inputW.value;
		else if (event.currentTarget == this.inputH)
			this.inputs.selectedItem.height = this.inputH.value;
		else if (event.currentTarget == this.inputR)
			this.inputs.canZoom.scene.transformHint.rotate(this.inputR.value / 180 * Math.PI);
		if (event.currentTarget != this.inputR)
			this.inputs.selectedItem.rotation = r;
	}

	override private function set_enabled(value:Bool):Bool {
		if (super.enabled == value)
			return super.enabled;

		if (value)
			this.updateData();
		return super.enabled = value;
	}

	public function updateData():Void {
		if (this.inputs.selectedItem == null)
			return;
		this.inputX.value = this.inputs.selectedItem.x;
		this.inputY.value = this.inputs.selectedItem.y;
		this.inputW.value = this.inputs.selectedItem.width;
		this.inputH.value = this.inputs.selectedItem.height;
		this.inputR.value = this.inputs.selectedItem.rotation;
	}
}
