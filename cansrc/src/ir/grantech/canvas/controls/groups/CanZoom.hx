package ir.grantech.canvas.controls.groups;

import haxe.Timer;
import feathers.events.FeathersEvent;
import feathers.controls.LayoutGroup;
import ir.grantech.services.BaseService;
import ir.grantech.services.InputService;
import ir.grantech.services.ToolsService;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	public var scene:CanScene;

	private var input:InputService;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var mask = new Shape();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, 0, 100, 100);
		this.scene.mask = mask;
		this.backgroundSkin = mask;

		this.input = cast(BaseService.get(InputService, [stage, this, this._layoutMeasurements]), InputService);
		this.input.addEventListener(InputService.PAN, this.input_panHandler);
		this.input.addEventListener(InputService.MOVE, this.input_moveHandler);
		this.input.addEventListener(InputService.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(InputService.POINT, this.input_pointHandler);
		this.input.addEventListener(InputService.DELETE, this.input_deleteHandler);
		this.input.addEventListener(InputService.ZOOM_RESET, this.input_zoomHandler);
		this.input.addEventListener(InputService.TRANSFORM_RESET, this.input_resetHandler);

		this.addEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
	}

	private function creationCompleteHandler(event:Event):Void {
		this.removeEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
		Timer.delay(this.resetZoomAndPan, 0);
	}

	private function input_moveHandler(event:Event):Void {
		this.scene.drawHit(this.hit(this.stage.mouseX, this.stage.mouseY));
	}

	private function input_panHandler(event:Event):Void {
		if (this.input.panPhase == InputService.PHASE_BEGAN)
			Mouse.cursor = MouseCursor.HAND;
		else if (this.input.panPhase == InputService.PHASE_ENDED)
			Mouse.cursor = MouseCursor.AUTO;

		this.scene.x = this.input.pointX;
		this.scene.y = this.input.pointY;
	}

	private function input_zoomHandler(event:Event):Void {
		if (event.type == InputService.ZOOM_RESET)
			this.resetZoomAndPan();
		else
			this.setZoom(this.input.zoom);
	}

	private function input_deleteHandler(event:Event):Void {
		this.input.selectedItem.parent.removeChild(this.input.selectedItem);
		this.input.selectedItem = null;
		if (this.scene.transformHint.parent != null)
			this.scene.removeChild(this.scene.transformHint);
	}

	private function input_pointHandler(event:Event):Void {
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

	private function input_resetHandler(event:Event):Void {
		this.scene.transformHint.resetTransform();
	}

	private function setZoom(value:Float):Void {
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.input.pointX = this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.input.pointY = this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);
	}

	private function resetZoomAndPan():Void {
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
