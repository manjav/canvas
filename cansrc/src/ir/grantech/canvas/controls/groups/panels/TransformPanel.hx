package ir.grantech.canvas.controls.groups.panels;

import ir.grantech.canvas.services.Inputs;
import feathers.controls.Button;
import feathers.controls.CanRangeInput;
import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.services.Commands;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class TransformPanel extends Panel {
	private var selfBounds:Rectangle;
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
			this.commands.commit(Commands.SCALE, [-this.target.scaleX, this.target.scaleY]);
		else if (event.currentTarget == this.buttonFlipV)
			this.commands.commit(Commands.SCALE, [this.target.scaleX, -this.target.scaleY]);
	}

	override private function textInputs_focusInHandler(event:FocusEvent):Void {
		Inputs.instance.canZoom.scene.transformHint.setVisible(false, event.currentTarget != this.inputR);
		cast(event.currentTarget, CanTextInput).addEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	override private function textInputs_focusOutHandler(event:FocusEvent):Void {
		Inputs.instance.canZoom.scene.transformHint.updateBounds();
		cast(event.currentTarget, CanTextInput).removeEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	private function textInputs_changeHandler(event:Event):Void {
		if (!this.targets.filled)
			return;

		if (event.currentTarget == this.inputX || event.currentTarget == this.inputY)
			this.commands.commit(Commands.TRANSLATE, [this.targets, this.inputX.value - this.targets.bounds.x, this.inputY.value - this.targets.bounds.y]);
		else if (event.currentTarget == this.inputW)
			this.commands.commit(Commands.SCALE, [this.inputW.value / this.selfBounds.width, this.target.scaleY]);
		else if (event.currentTarget == this.inputH)
			this.commands.commit(Commands.SCALE, [this.target.scaleX, this.inputH.value / this.selfBounds.height]);
		else if (event.currentTarget == this.inputR)
			this.commands.commit(Commands.ROTATE, [this.inputR.value / 180 * Math.PI]);
	}

override public function updateData():Void {
		if (this.targets == null || !this.targets.filled)
			return;
		this.inputX.value = this.targets.bounds.x;
		this.inputY.value = this.targets.bounds.y;
		if (this.targets.length == 1) {
			// this.inputR.value = this.targets.rotation;
			// this.selfBounds = this.targets.getBounds(cast(this.targets, DisplayObject));
			// this.inputW.value = this.selfBounds.width * this.targets.scaleX;
			// this.inputH.value = this.selfBounds.height * this.targets.scaleY;
		}
	}
}
