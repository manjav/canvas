package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.events.FeathersEvent;
import haxe.Timer;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.BaseService;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Tools;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	public var scene:CanScene;
	public var focused:Bool;

	private var input:Inputs;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var background = new Shape();
		background.graphics.beginFill(0, 0);
		background.graphics.drawRect(0, 0, 100, 100);
		this.backgroundSkin = background;

		var commands = cast(BaseService.get(Commands), Commands);
		commands.addEventListener(Commands.ADDED, this.commands_addedHandler);
		commands.addEventListener(Commands.REMOVED, this.commands_removedHandler);
		commands.addEventListener(Commands.SELECT, this.commands_selectHandler);
		commands.addEventListener(Commands.RESET, this.commands_resetHandler);
		commands.addEventListener(Commands.SCALE, this.commands_transformHandler);
		commands.addEventListener(Commands.ROTATE, this.commands_transformHandler);
		commands.addEventListener(Commands.VISIBLE, this.commands_transformHandler);

		this.input = cast(BaseService.get(Inputs, [stage, this]), Inputs);
		this.input.addEventListener(Inputs.HIT, this.input_hitHandler);
		this.input.addEventListener(Inputs.PAN, this.input_panHandler);
		this.input.addEventListener(Inputs.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(Inputs.POINT, this.input_pointHandler);
		this.input.addEventListener(Inputs.ZOOM_RESET, this.input_zoomHandler);

		this.addEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
	}

	private function creationCompleteHandler(event:Event):Void {
		this.removeEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
		Timer.delay(this.resetZoomAndPan, 0);
	}

	// ------ commands listeners ------
	private function commands_addedHandler(event:CanEvent):Void {
		this.scene.container.addChild(cast event.data[0]);
	}

	private function commands_removedHandler(event:CanEvent):Void {
		this.scene.transformHint.set(null);
		this.scene.container.removeChild(cast event.data[0]);
	}

	private function commands_transformHandler(event:CanEvent):Void {
		if (event.type == Commands.SCALE)
			this.scene.transformHint.scale(event.data[0], event.data[1]);
		else if (event.type == Commands.ROTATE)
			this.scene.transformHint.rotate(event.data[0]);
		else if (event.type == Commands.VISIBLE)
			cast(event.data[0], ICanItem).visible = event.data[1];
	}

	private function commands_selectHandler(event:CanEvent):Void {
		if (event.data[0] == null)
			this.scene.transformHint.set(null);
		else
			this.scene.transformHint.set(event.data[0]);
	}

	private function commands_changeVisibleHandler(event:CanEvent):Void {}

	private function commands_resetHandler(event:CanEvent):Void {
		this.scene.transformHint.resetTransform();
	}

	// ------ inputs listeners ------
	private function input_hitHandler(event:CanEvent):Void {
		this.scene.drawHit(cast event.data);
	}

	private function input_panHandler(event:CanEvent):Void {
		if (this.input.panPhase == Inputs.PHASE_BEGAN)
			Mouse.cursor = MouseCursor.HAND;
		else if (this.input.panPhase == Inputs.PHASE_ENDED)
			Mouse.cursor = MouseCursor.AUTO;

		this.scene.x = this.input.pointX;
		this.scene.y = this.input.pointY;
	}

	private function input_zoomHandler(event:CanEvent):Void {
		if (event.type == Inputs.ZOOM_RESET)
			this.resetZoomAndPan();
		else
			this.setZoom(this.input.zoom);
	}

	@:access(ir.grantech.canvas.services.Inputs)
	private function input_pointHandler(event:CanEvent):Void {
		if (input.pointPhase == Inputs.PHASE_ENDED) {
			this.scene.transformHint.updateBounds();
			this.scene.hitHint.graphics.clear();
			return;
		}

		if (Tools.instance.toolType != Tool.SELECT)
			return;

		if (this.input.selectedItem != null)
			this.scene.transformHint.perform(input.pointPhase);
		else
			this.scene.updateSlection(input.pointPhase);
	}

	private function setZoom(value:Float):Void {
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.input.pointX = this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.input.pointY = this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);
	}

	public function resetZoomAndPan():Void {
		this.setZoom(1);
		this.scene.x = this.input.pointX = (this.explicitWidth - this.scene.canWidth) * 0.5;
		this.scene.y = this.input.pointY = (this.explicitHeight - this.scene.canHeight) * 0.5;
	}
}
