package ir.grantech.canvas.services;

import ir.grantech.canvas.controls.TransformHint;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Tools.Tool;
import lime.ui.KeyCode;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class Inputs extends BaseService {
	static public final PHASE_BEGAN:Int = 0;
	static public final PHASE_UPDATE:Int = 1;
	static public final PHASE_ENDED:Int = 2;

	static public final HIT:String = "hit";
	static public final PAN:String = "pan";
	static public final ZOOM:String = "zoom";
	static public final POINT:String = "point";
	static public final ZOOM_RESET:String = "zoomReset";

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

	private var selectedItems:CanItems;
	private var reservedX:Float = 0;
	private var reservedY:Float = 0;
	private var stage:Stage;
	private var selection:Rectangle;
	private var beganCanItem:Bool;

	/**
		The singleton method of Inputs.
		```hx
		Inputs.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Inputs;

	static private function get_instance():Inputs {
		return BaseService.get(Inputs);
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
		CanEvent.dispatch(this, ZOOM);
		return this.zoom;
	}

	public var hit(default, set):ICanItem;

	private function set_hit(value:ICanItem):ICanItem {
		if (this.hit == value)
			return value;
		this.hit = value;
		CanEvent.dispatch(this, HIT, value);
		return value;
	}

	public function new(stage:Stage, canZoom:CanZoom) {
		super();
		this.stage = stage;
		this.canZoom = canZoom;
		this.selectedItems = new CanItems();

		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);

		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this.stage_middleMouseDownHandler);
		this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, this.stage_middleMouseUpHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		this.canZoom.addEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
	}

	private function stage_keyDownHandler(event:KeyboardEvent):Void {
		if (event.keyCode == 16 || event.keyCode == 17 || event.keyCode > 36 && event.keyCode < 41) {
			if (!this.canZoom.focused || event.keyCode == 16 || event.keyCode == 17 || !this.selectedItems.filled)
				return;
			if (event.keyCode == 37)
				this.selectedItems.translate(event.shiftKey ? -10 : -1, 0);
			else if (event.keyCode == 38)
				this.selectedItems.translate(0, event.shiftKey ? -10 : -1);
			else if (event.keyCode == 39)
				this.selectedItems.translate(event.shiftKey ? 10 : 1, 0);
			else if (event.keyCode == 40)
				this.selectedItems.translate(0, event.shiftKey ? 10 : 1);
			this.panPhase = PHASE_ENDED;
			CanEvent.dispatch(this, POINT);
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
				CanEvent.dispatch(this, ZOOM_RESET);
			} else if (this.lastKeyUp == 187) { // ctrl + =
				this.zoom += 0.3;
				CanEvent.dispatch(this, ZOOM);
			} else if (this.lastKeyUp == 189) { // ctrl + -
				this.zoom -= 0.3;
				CanEvent.dispatch(this, ZOOM);
			} else if (this.selectedItems != null && event.shiftKey && this.lastKeyUp == 90) { // ctrl + shift + z
				this.commands.commit(Commands.RESET, [this.selectedItems]);
			}
		}

		if (this.canZoom.focused && this.lastKeyUp == 46 && this.selectedItems != null) {
			this.commands.commit(Commands.REMOVED, [this.selectedItems]);
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
			CanEvent.dispatch(this, PAN);
			return;
		}

		this.canZoom.focused = this.canZoom.getBounds(stage).contains(event.stageX, event.stageY);
		var item = this.hitTest(this.stage.mouseX, this.stage.mouseY);
		this.beganCanItem = Std.is(item, ICanItem) || Std.is(item, TransformHint);
		if (!Std.is(item, TransformHint)) {
			if (this.beganCanItem) {
				var i = cast(item, ICanItem);
				var exists = this.selectedItems.indexOf(i) > -1;
				if (this.shiftKey || this.ctrlKey) {
					if (exists)
						this.selectedItems.remove(i);
					else
						this.selectedItems.add(i);
				} else if (!exists) {
					this.selectedItems.removeAll();
					this.selectedItems.add(i);
				}
			} else if (this.canZoom.focused) {
				this.selectedItems.removeAll();
			}
		}
		this.pointPhase = PHASE_BEGAN;
		CanEvent.dispatch(this, POINT);
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.mouseDown = false;
		if (this.panPhase == PHASE_UPDATE) {
			this.panPhase = PHASE_ENDED;
			CanEvent.dispatch(this, PAN);
			return;
		}
		this.pointPhase = PHASE_ENDED;
		CanEvent.dispatch(this, POINT);
	}

	private function stage_middleMouseDownHandler(event:MouseEvent):Void {
		this.reservedX = this.stage.mouseX;
		this.reservedY = this.stage.mouseY;
		this.shiftKey = event.shiftKey;
		this.ctrlKey = event.ctrlKey;
		this.altKey = event.altKey;
		this.middleMouseDown = true;
		this.panPhase = PHASE_BEGAN;
		CanEvent.dispatch(this, PAN);
	}

	private function stage_middleMouseUpHandler(event:MouseEvent):Void {
		this.middleMouseDown = false;
		this.panPhase = PHASE_ENDED;
		CanEvent.dispatch(this, PAN);
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
			CanEvent.dispatch(this, PAN);
			this.reservedX = this.stage.mouseX;
			this.reservedY = this.stage.mouseY;
		} else if (this.mouseDown) {
			if (this.canZoom.focused) {
				this.pointPhase = PHASE_UPDATE;
				CanEvent.dispatch(this, POINT);
			}
		} else {
			var hit = this.hitTest(this.stage.mouseX, this.stage.mouseY);
			if (hit != null && Std.is(hit, ICanItem)) {
				var h = cast(hit, ICanItem);
				this.hit = selectedItems.indexOf(h) == -1 ? h : null;
			} else {
				this.hit = null;
			}
			// CanEvent.dispatch(this, MOVE);
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

		CanEvent.dispatch(this, PAN);
	}

	public function hitTest(x:Float, y:Float):DisplayObject {
		if (Tools.instance.toolType != Tool.SELECT)
			return null;
		for (i in 0...this.canZoom.scene.container.numChildren)
			if (this.canZoom.scene.container.getChildAt(i).hitTestPoint(x, y, true))
				return this.canZoom.scene.container.getChildAt(i);
		if (this.canZoom.scene.transformHint.hitTestPoint(x, y, true))
			return this.canZoom.scene.transformHint;
		return null;
	}
}
