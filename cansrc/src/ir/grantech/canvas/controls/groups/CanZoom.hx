package ir.grantech.canvas.controls.groups;

import openfl.events.Event;
import ir.grantech.services.BaseService;
import ir.grantech.utils.Utils;
import feathers.controls.LayoutGroup;
import ir.grantech.services.InputService;
import openfl.display.Shape;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
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

		this.input = cast(BaseService.get(InputService, [stage, this._layoutMeasurements]), InputService);
		this.input.addEventListener(InputService.PAN, this.input_panHandler);
		this.input.addEventListener(InputService.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(InputService.POINT, this.input_pointHandler);
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

	private function setZoom(value:Float):Void {
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);
	}
}
