package ir.grantech.services;

import ir.grantech.canvas.drawables.ICanItem;
import feathers.events.FeathersEvent;
import feathers.layout.Measurements;
import ir.grantech.canvas.controls.groups.CanScene;
import lime.ui.KeyCode;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

class InputService extends BaseService {
	static public final PAN:String = "pan";
	static public final ZOOM:String = "zoom";
	static public final POINT:String = "point";
	static public final RESET:String = "reset";

	public var panState:Int = 2;
	public var pointState:Int = 2;
	public var lastKeyDown:Int = 0;
	public var lastKeyUp:Int = 0;
	public var mouseDown:Bool;
	public var middleMouseDown:Bool;
	public var rightMouseDown:Bool;
	public var pointX:Float = 0;
	public var pointY:Float = 0;

	private var reservedX:Float = 0;
	private var reservedY:Float = 0;
	private var stage:Stage;
	private var scene:CanScene;
	private var measurements:Measurements;

	/**
		The singleton method of InputService.
		```hx
		InputService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):InputService;

	static private function get_instance():InputService {
		return BaseService.get(InputService);
	}

	public var zoom(default, set):Float = 1;

	private function set_zoom(value:Float):Float {
		if (0.1 > value)
			value = 0.3;
		if (10 < value)
			value = 10;
		if (this.zoom == value)
			return this.zoom;

		this.zoom = value;
		FeathersEvent.dispatch(this, ZOOM);
		return this.zoom;
	}

	public function new(stage:Stage, scene:CanScene, measurements:Measurements) {
		super();
		this.stage = stage;
		this.scene = scene;
		this.measurements = measurements;

		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);

		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_middleMouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, this.stage_middleMouseUpHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
		this.stage.addEventListener(MouseEvent.CLICK, this.stage_clickHandler);
	}

	private function stage_keyDownHandler(event:KeyboardEvent):Void {
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, this.stage_keyUpHandler);
		this.lastKeyDown = event.keyCode;
		this.lastKeyUp = 0;
	}

	private function stage_keyUpHandler(event:KeyboardEvent):Void {
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
		this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.stage_keyUpHandler);
		this.lastKeyUp = event.keyCode;
		this.lastKeyDown = 0;

		// trace(StringTools.hex(this.lastKeyUp));
		if (event.ctrlKey) {
			if (this.lastKeyUp == KeyCode.NUMBER_0) {
				this.zoom = 1;
				this.pointX = 0;
				this.pointY = 0;
				FeathersEvent.dispatch(this, RESET);
			} else if (this.lastKeyUp == 187) {
				this.zoom += 0.3;
				FeathersEvent.dispatch(this, ZOOM);
			} else if (this.lastKeyUp == 189) {
				this.zoom -= 0.3;
				FeathersEvent.dispatch(this, ZOOM);
			}
		}
	}

	private function stage_clickHandler(event:MouseEvent):Void {
		var item = this.scene.hit(this.stage.mouseX, this.stage.mouseY);
		if (Std.is(item, ICanItem)) {
			this.scene.selectionHint.set(item.x, item.y, item.width, item.height);
			this.scene.selectionHint.visible = true;
			return;
		}
		this.scene.selectionHint.visible = false;
	}

	private function stage_mouseDownHandler(event:MouseEvent):Void {
		this.mouseDown = true;
		this.reservedX = event.stageX;
		this.reservedY = event.stageY;
		if (this.lastKeyDown == KeyCode.SPACE) {
			this.panState = 0;
			FeathersEvent.dispatch(this, PAN);
			return;
		}
		this.pointState = 0;
		FeathersEvent.dispatch(this, POINT);
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.mouseDown = false;
		if (this.panState == 1) {
			this.panState = 2;
			FeathersEvent.dispatch(this, PAN);
			return;
		}
		this.pointState = 2;
		FeathersEvent.dispatch(this, POINT);
	}

	private function stage_middleMouseDownHandler(event:MouseEvent):Void {
		this.reservedX = this.stage.mouseX;
		this.reservedY = this.stage.mouseY;
		this.middleMouseDown = true;
		this.panState = 0;
		FeathersEvent.dispatch(this, PAN);
	}

	private function stage_middleMouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.panState = 2;
		FeathersEvent.dispatch(this, PAN);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		event.updateAfterEvent();
		if (this.middleMouseDown || (this.mouseDown && this.lastKeyDown == KeyCode.SPACE)) {
			this.panState = 1;
			this.pointX += (this.stage.mouseX - this.reservedX);
			this.pointY += (this.stage.mouseY - this.reservedY);
			FeathersEvent.dispatch(this, PAN);
			this.reservedX = this.stage.mouseX;
			this.reservedY = this.stage.mouseY;
		} else if (this.mouseDown) {
			this.pointState = 1;
			FeathersEvent.dispatch(this, POINT);
		} else {
			this.scene.drawHit(this.scene.hit(this.stage.mouseX, this.stage.mouseY));
		}
	}

	private function stage_mouseWheelHandler(event:MouseEvent):Void {
		var zoomMode = event.altKey || event.ctrlKey;
		#if mac
		zoomMode = zoomMode || event.commandKey;
		#end

		if (zoomMode) {
			this.zoom += event.delta * this.zoom * 0.1;
			return;
		}

		if (event.shiftKey)
			this.pointX += event.delta * 10;
		else
			this.pointY += event.delta * 10;

		FeathersEvent.dispatch(this, PAN);
	}
}
