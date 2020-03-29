package ir.grantech.services;

import feathers.events.FeathersEvent;
import feathers.layout.Measurements;
import ir.grantech.canvas.controls.groups.CanZoom;
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
	static public final DELETE:String = "delete";
	static public final ZOOM_RESET:String = "zoomReset";
	static public final TRANSFORM_RESET:String = "transformReset";

	public var panPhase:Int = 2;
	public var pointPhase:Int = 2;
	public var lastKeyDown:Int = 0;
	public var lastKeyUp:Int = 0;
	public var ctrlKey:Bool;
	public var shiftKey:Bool;
	public var altKey:Bool;
	public var mouseDown:Bool;
	public var middleMouseDown:Bool;
	public var rightMouseDown:Bool;
	public var pointX:Float = 0;
	public var pointY:Float = 0;
	public var canZoom:CanZoom;

	private var reservedX:Float = 0;
	private var reservedY:Float = 0;
	private var stage:Stage;
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

	public function new(stage:Stage, canZoom:CanZoom, measurements:Measurements) {
		super();
		this.stage = stage;
		this.canZoom = canZoom;
		this.measurements = measurements;

		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);

		this.canZoom.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		this.canZoom.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_middleMouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, this.stage_middleMouseUpHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		this.canZoom.addEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
	}

	private function stage_keyDownHandler(event:KeyboardEvent):Void {
		if (event.keyCode == 16 || event.keyCode == 17 || event.keyCode > 36 && event.keyCode < 41) {
			if (!this.canZoom.focused || event.keyCode == 16 || event.keyCode == 17 || this.selectedItem == null)
				return;
			if (event.keyCode == 37)
				this.selectedItem.x -= (event.shiftKey ? 10 : 1);
			else if (event.keyCode == 38)
				this.selectedItem.y -= (event.shiftKey ? 10 : 1);
			else if (event.keyCode == 39)
				this.selectedItem.x += (event.shiftKey ? 10 : 1);
			else if (event.keyCode == 40)
				this.selectedItem.y += (event.shiftKey ? 10 : 1);
			this.panPhase = PHASE_ENDED;
			FeathersEvent.dispatch(this, POINT);
			return;
		}

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

		if (this.lastKeyUp == 46 && this.selectedItem != null) {
			FeathersEvent.dispatch(this, DELETE);
			return;
		}
	}

	private function stage_mouseDownHandler(event:MouseEvent):Void {
		this.mouseDown = true;
		this.shiftKey = event.shiftKey;
		this.ctrlKey = event.ctrlKey;
		this.altKey = event.altKey;
		this.reservedX = event.stageX;
		this.reservedY = event.stageY;
		if (this.lastKeyDown == KeyCode.SPACE) {
			this.panPhase = PHASE_BEGAN;
			FeathersEvent.dispatch(this, PAN);
			return;
		}

		var item = this.canZoom.hit(this.stage.mouseX, this.stage.mouseY);
		if (Std.is(item, ICanItem)) {
			this.selectedItem = item;
			this.canZoom.focused = true;
		} else {
			this.canZoom.focused = false;
			if (Std.is(item, CanZoom))
				this.selectedItem = null;
		}
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
		this.shiftKey = event.shiftKey;
		this.ctrlKey = event.ctrlKey;
		this.altKey = event.altKey;
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
		this.shiftKey = event.shiftKey;
		this.ctrlKey = event.ctrlKey;
		this.altKey = event.altKey;
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
