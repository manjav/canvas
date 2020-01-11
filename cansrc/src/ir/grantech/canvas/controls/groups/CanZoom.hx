package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import ir.grantech.services.ToolsService;
import openfl.display.Shape;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	private var scene:CanScene;

	public var scale(default, set):Float = 1;

	private function set_scale(value:Float):Float {
		if (0.1 > value)
			value = 0.3;
		if (10 < value)
			value = 10;
		if (this.scale == value)
			return this.scale;

		this.scale = value;
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);

		return this.scale;
	}

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var mask = new Shape();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, 0, 100, 100);
		this.scene.mask = mask;
		this.backgroundSkin = mask;

		this.stage.addEventListener(KeyboardEvent.KEY_UP, this.stage_keyUpHandler);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
	}

	private function stage_keyDownHandler(event:KeyboardEvent):Void {
		if (event.keyCode != 32) // is not space bar
			return;
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		var dragMode = mouseX > 0 && mouseX < this._layoutMeasurements.width;
		Mouse.cursor = dragMode ? MouseCursor.HAND : MouseCursor.AUTO;
	}

	private function stage_keyUpHandler(event:KeyboardEvent):Void {
		if (event.keyCode == 0x30) {
			if (event.ctrlKey)
				this.scene.scaleX = this.scene.scaleY = 1;
			return;
		}
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		this.drop();
	}

	private function stage_mouseDownHandler(event:MouseEvent):Void {
		this.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, this.stage_mouseUpHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		if (event.type == MouseEvent.MOUSE_DOWN && Mouse.cursor != MouseCursor.HAND)
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.scene_mouseMoveHandler);
			return;
		}
		this.drag();
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.scene_mouseMoveHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_mouseDownHandler);
		this.scene.release();
		this.drop();
	}

	private function stage_mouseWheelHandler(event:MouseEvent):Void {
		var zoomMode = event.altKey || event.ctrlKey;
		#if mac
		zoomMode = zoomMode || event.commandKey;
		#end

		if (zoomMode)
			this.scale += event.delta * this.scene.scaleX * 0.1;
		else if (event.shiftKey)
			this.scene.x += event.delta * 10;
		else
			this.scene.y += event.delta * 10;
	}

	private function drag():Void {
		Mouse.cursor = MouseCursor.HAND;
		this.scene.startDrag();
	}

	private function drop():Void {
		this.scene.stopDrag();
		Mouse.cursor = MouseCursor.AUTO;
	}

	private function scene_mouseMoveHandler(event:MouseEvent):Void {
		event.updateAfterEvent();

		if (ToolsService.instance.toolType == Tool.SELECT) {
			this.scene.selectionLayer.graphics.clear();
			this.scene.selectionLayer.graphics.beginFill(0x00FFFF, 0.2);
			this.scene.selectionLayer.graphics.lineStyle(0.5, 0xFFFFFF);
			this.scene.selectionLayer.graphics.drawRect(0,0,event.localX, event.localY);
			return;
		}
		// this.scene.x = event.localX;
		// this.scene.y = event.localY;
	}
}
