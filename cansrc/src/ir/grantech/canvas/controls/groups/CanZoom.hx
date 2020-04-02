package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.events.FeathersEvent;
import haxe.Timer;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.services.BaseService;
import ir.grantech.services.CommandsService;
import ir.grantech.services.InputService;
import ir.grantech.services.ToolsService;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	public var scene:CanScene;
	public var focused:Bool;

	private var input:InputService;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var background = new Shape();
		background.graphics.beginFill(0, 0);
		background.graphics.drawRect(0, 0, 100, 100);
		this.backgroundSkin = background;

		var commands = cast(BaseService.get(CommandsService), CommandsService);
		commands.addEventListener(CommandsService.ADDED, this.commands_addedHandler);
		commands.addEventListener(CommandsService.REMOVED, this.commands_removedHandler);
		commands.addEventListener(CommandsService.SELECT, this.commands_selectHandler);
		commands.addEventListener(CommandsService.RESET, this.commands_resetHandler);

		this.input = cast(BaseService.get(InputService, [stage, this]), InputService);
		this.input.addEventListener(InputService.PAN, this.input_panHandler);
		this.input.addEventListener(InputService.MOVE, this.input_moveHandler);
		this.input.addEventListener(InputService.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(InputService.POINT, this.input_pointHandler);
		this.input.addEventListener(InputService.ZOOM_RESET, this.input_zoomHandler);

		this.addEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
	}

	private function creationCompleteHandler(event:Event):Void {
		this.removeEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
		Timer.delay(this.resetZoomAndPan, 0);
	}

	// ------ commands listeners ------
	private function commands_addedHandler(event:CanEvent):Void {
		this.scene.container.addChild(cast(event.data[0], DisplayObject));
	}

	private function commands_removedHandler(event:CanEvent):Void {
		this.scene.container.removeChild(cast this.input.selectedItem);
		this.input.selectedItem = null;
		if (this.scene.transformHint.parent != null)
			this.scene.removeChild(this.scene.transformHint);
	}

	private function commands_selectHandler(event:CanEvent):Void {}

	private function commands_changeVisibleHandler(event:CanEvent):Void {}

	private function commands_resetHandler(event:CanEvent):Void {
		this.scene.transformHint.resetTransform();
	}

	// ------ inputs listeners ------
	private function input_moveHandler(event:CanEvent):Void {
		var target = this.hit(this.stage.mouseX, this.stage.mouseY);
		if (target != null && Std.is(target, ICanItem))
			this.scene.drawHit(cast(target, ICanItem));
	}

	private function input_panHandler(event:CanEvent):Void {
		if (this.input.panPhase == InputService.PHASE_BEGAN)
			Mouse.cursor = MouseCursor.HAND;
		else if (this.input.panPhase == InputService.PHASE_ENDED)
			Mouse.cursor = MouseCursor.AUTO;

		this.scene.x = this.input.pointX;
		this.scene.y = this.input.pointY;
	}

	private function input_zoomHandler(event:CanEvent):Void {
		if (event.type == InputService.ZOOM_RESET)
			this.resetZoomAndPan();
		else
			this.setZoom(this.input.zoom);
	}

	private function input_pointHandler(event:CanEvent):Void {
		if (input.pointPhase == InputService.PHASE_BEGAN) {
			this.scene.hitHint.visible = false;
			if (ToolsService.instance.toolType == Tool.SELECT) {
				if (this.input.selectedItem != null) {
					this.scene.addChild(this.scene.transformHint);
					this.scene.transformHint.set(this.input.selectedItem);
					this.scene.transformHint.perform(input.pointPhase);
				} else {
					if (this.scene.transformHint.parent != null)
						this.scene.removeChild(this.scene.transformHint);
					this.scene.updateSlection(true);
				}
			}
		} else if (input.pointPhase == InputService.PHASE_UPDATE) {
			if (ToolsService.instance.toolType == Tool.SELECT) {
				if (this.input.selectedItem != null)
					this.scene.transformHint.perform(input.pointPhase);
				else
					this.scene.updateSlection();
			}
		} else {
			this.scene.selectHint.visible = false;
			if (this.input.selectedItem != null)
				this.scene.transformHint.set(this.input.selectedItem);
		}
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

	public function hit(x:Float, y:Float):DisplayObject {
		if (this.scene.transformHint.hitTestPoint(x, y, true))
			return this.scene.transformHint;
		for (i in 0...this.scene.container.numChildren)
			if (this.scene.container.getChildAt(i).hitTestPoint(x, y, true))
				return this.scene.container.getChildAt(i);
		if (this.hitTestPoint(x, y, true))
			return this;
		return null;
	}
}
