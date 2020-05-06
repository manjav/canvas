package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.Button;
import feathers.controls.CanRangeInput;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class TransformSection extends CanSection {
	override private function set_targets(value:CanItems):CanItems {
		super.set_targets(value);
		this.buttonFlipH.enabled = value.length == 1;
		this.buttonFlipV.enabled = value.length == 1;
		return value;
	}

	private var inputX:CanRangeInput;
	private var inputY:CanRangeInput;
	private var inputW:CanRangeInput;
	private var inputH:CanRangeInput;
	private var inputR:CanRangeInput;
	private var buttonFlipH:Button;
	private var buttonFlipV:Button;
	private var sizeRect:Rectangle = new Rectangle();

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		// this.title = "TRANSFORM";

		this.inputX = this.createRangeInput("x", new AnchorLayoutData(padding * 1, null, null, padding));
		this.inputY = this.createRangeInput("y", new AnchorLayoutData(padding * 4, null, null, padding));
		this.inputW = this.createRangeInput("w", new AnchorLayoutData(padding * 1, null, null, null, 0));
		this.inputH = this.createRangeInput("h", new AnchorLayoutData(padding * 4, null, null, null, 0));
		this.inputR = this.createRangeInput("rotate", new AnchorLayoutData(padding * 1, padding));

		this.buttonFlipH = this.createButton("flip-h", new AnchorLayoutData(padding * 4, padding * 4));
		this.buttonFlipV = this.createButton("flip-v", new AnchorLayoutData(padding * 4, padding * 1));

		this.height = padding * 7.5;
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		if (event.currentTarget == this.buttonFlipH)
			this.commands.commit(Commands.SCALE, [this.targets, -this.targets.get(0).scaleX, this.targets.get(0).scaleY]);
		else if (event.currentTarget == this.buttonFlipV)
			this.commands.commit(Commands.SCALE, [this.targets, this.targets.get(0).scaleX, -this.targets.get(0).scaleY]);
	}

	override private function textInputs_focusInHandler(event:FocusEvent):Void {
		Inputs.instance.canZoom.transformHint.setVisible(false, event.currentTarget != this.inputR);
		cast(event.currentTarget, CanRangeInput).addEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	override private function textInputs_focusOutHandler(event:FocusEvent):Void {
		Inputs.instance.canZoom.transformHint.updateBounds();
		cast(event.currentTarget, CanRangeInput).removeEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	private function textInputs_changeHandler(event:Event):Void {
		if (this.targets.isEmpty)
			return;

		if (event.currentTarget == this.inputX || event.currentTarget == this.inputY) {
			this.commands.commit(Commands.TRANSLATE, [
				this.targets,
				this.inputX.value - this.targets.bounds.x,
				this.inputY.value - this.targets.bounds.y
			]);
		} else if (event.currentTarget == this.inputW || event.currentTarget == this.inputH) {
			if (event.currentTarget == this.inputW)
				this.sizeRect.setTo(this.targets.bounds.x, this.targets.bounds.y, this.inputW.value, this.targets.bounds.height);
			else
				this.sizeRect.setTo(this.targets.bounds.x, this.targets.bounds.y, this.targets.bounds.width, this.inputH.value);
			this.commands.commit(Commands.RESIZE, [this.targets, this.sizeRect]);
		} else if (event.currentTarget == this.inputR) {
			this.commands.commit(Commands.ROTATE, [this.targets, this.inputR.value / 180 * Math.PI]);
		}
	}

	override public function updateData():Void {
		if (this.targets == null || this.targets.isEmpty)
			return;
		this.updating = true;
		this.inputR.value = this.targets.length == 1 ? this.targets.get(0).rotation : 0;
		this.inputX.value = this.targets.bounds.x;
		this.inputY.value = this.targets.bounds.y;
		this.inputW.value = this.targets.bounds.width;
		this.inputH.value = this.targets.bounds.height;

		this.updating = false;
	}
}
