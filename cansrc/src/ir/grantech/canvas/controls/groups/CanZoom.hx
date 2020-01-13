package ir.grantech.canvas.controls.groups;

import feathers.events.FeathersEvent;
import feathers.controls.LayoutGroup;
import ir.grantech.services.BaseService;
import ir.grantech.services.InputService;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	private var scene:CanScene;
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

		this.input = cast(BaseService.get(InputService, [stage, this.scene, this._layoutMeasurements]), InputService);
		this.input.addEventListener(InputService.PAN, this.input_panHandler);
		this.input.addEventListener(InputService.MOVE, this.input_moveHandler);
		this.input.addEventListener(InputService.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(InputService.POINT, this.input_pointHandler);
		this.input.addEventListener(InputService.RESET, this.input_resetHandler);
		this.input.addEventListener(InputService.CLICK, this.input_clickHandler);
	}

	private function input_moveHandler(event:Event):Void {
		this.scene.drawHit(this.scene.hit(this.stage.mouseX, this.stage.mouseY));
	}

	private function input_clickHandler(event:Event):Void {
		var item = this.scene.hit(this.stage.mouseX, this.stage.mouseY);
		if (Std.is(item, ICanItem)) {
			this.scene.transformHint.set(item.x, item.y, item.width, item.height);
			this.scene.transformHint.visible = true;
			return;
		}
	}

	private function input_panHandler(event:Event):Void {
		if (this.input.panState == 0)
			Mouse.cursor = MouseCursor.HAND;
		else if (this.input.panState == 2)
			Mouse.cursor = MouseCursor.AUTO;

		this.scene.x = this.input.pointX;
		this.scene.y = this.input.pointY;
	}

	private function input_zoomHandler(event:Event):Void {
		this.setZoom(this.input.zoom);
	}
	
	private function input_pointHandler(event:Event):Void {
		if (input.pointState == 0)
			this.scene.startDraw();
		else if (input.pointState == 2)
			this.scene.stopDraw();
		else
			this.scene.updateDraw();
	}

	private function input_resetHandler(event:Event):Void {
		this.setZoom(1);
		this.scene.x = this.input.pointX = (this._layoutMeasurements.width - this.scene.canWidth) * 0.5;
		this.scene.y = this.input.pointY = (this._layoutMeasurements.height - this.scene.canHeight) * 0.5;
	}

	private function setZoom(value:Float):Void {
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.input.pointX = this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.input.pointY = this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);
	}
}
