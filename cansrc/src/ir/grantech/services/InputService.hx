package ir.grantech.services;

import feathers.events.FeathersEvent;
import feathers.layout.Measurements;
import ir.grantech.canvas.controls.TransformHint;
import ir.grantech.canvas.controls.groups.CanScene;
import ir.grantech.canvas.drawables.ICanItem;
import lime.ui.KeyCode;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

class InputService extends BaseService {
	static public final PHASE_BEGAN:Int = 0;
	static public final PHASE_UPDATE:Int = 1;
	static public final PHASE_ENDED:Int = 2;

	static public final PAN:String = "pan";
	static public final ZOOM:String = "zoom";
	static public final MOVE:String = "move";
	static public final POINT:String = "point";
	static public final SELECT:String = "select";
	static public final ZOOM_RESET:String = "zoomReset";
	static public final TRANSFORM_RESET:String = "transformReset";

	public var panPhase:Int = 2;
	public var pointPhase:Int = 2;
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

	public var selectedItem(default, set):DisplayObject;

	private function set_selectedItem(value:DisplayObject):DisplayObject {
		if (this.selectedItem == value)
			return this.selectedItem;
		this.selectedItem = value;
		FeathersEvent.dispatch(this, SELECT);
		return this.selectedItem;
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
				FeathersEvent.dispatch(this, ZOOM_RESET);
			} else if (this.lastKeyUp == 187) { // ctrl + =
				this.zoom += 0.3;
				FeathersEvent.dispatch(this, ZOOM);
			} else if (this.lastKeyUp == 189) { // ctrl + -
				this.zoom -= 0.3;
				FeathersEvent.dispatch(this, ZOOM);
			} else if (this.selectedItem != null && event.shiftKey && this.lastKeyUp == 90) { // ctrl + shift + z
				FeathersEvent.dispatch(this, TRANSFORM_RESET);
			}
		}
	}

	private function stage_mouseDownHandler(event:MouseEvent):Void {
		this.mouseDown = true;
		this.reservedX = event.stageX;
		this.reservedY = event.stageY;
		if (this.lastKeyDown == KeyCode.SPACE) {
			this.panPhase = PHASE_BEGAN;
			FeathersEvent.dispatch(this, PAN);
			return;
		}

		var item = this.scene.hit(this.stage.mouseX, this.stage.mouseY);
		if (Std.is(item, ICanItem))
			this.selectedItem = item;
		else if (!Std.is(item, TransformHint))
			this.selectedItem = null;

		this.pointPhase = PHASE_BEGAN;
		FeathersEvent.dispatch(this, POINT);
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.mouseDown = false;
		if (this.panPhase == PHASE_UPDATE) {
			this.panPhase = PHASE_ENDED;
			FeathersEvent.dispatch(this, PAN);
			return;
		}
		this.pointPhase = PHASE_ENDED;
		FeathersEvent.dispatch(this, POINT);
	}

	private function stage_middleMouseDownHandler(event:MouseEvent):Void {
		this.reservedX = this.stage.mouseX;
		this.reservedY = this.stage.mouseY;
		this.middleMouseDown = true;
		this.panPhase = PHASE_BEGAN;
		FeathersEvent.dispatch(this, PAN);
	}

	private function stage_middleMouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.panPhase = PHASE_ENDED;
		FeathersEvent.dispatch(this, PAN);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		event.updateAfterEvent();
		if (this.middleMouseDown || (this.mouseDown && this.lastKeyDown == KeyCode.SPACE)) {
			this.panPhase = PHASE_UPDATE;
			this.pointX += (this.stage.mouseX - this.reservedX);
			this.pointY += (this.stage.mouseY - this.reservedY);
			FeathersEvent.dispatch(this, PAN);
			this.reservedX = this.stage.mouseX;
			this.reservedY = this.stage.mouseY;
		} else if (this.mouseDown) {
			this.pointPhase = PHASE_UPDATE;
			FeathersEvent.dispatch(this, POINT);
		} else {
			FeathersEvent.dispatch(this, MOVE);
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
