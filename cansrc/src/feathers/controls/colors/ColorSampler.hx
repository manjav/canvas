package feathers.controls.colors;

import feathers.events.FeathersEvent;
import lime.math.RGB;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.ui.Mouse;

class ColorSampler extends Sprite {
	public var rgb(default, default):RGB;

	private var radius:Float;
	private var matrix:Matrix;
	private var magnify:Shape;
	private var pointer:Sprite;
	private var sampleData:BitmapData;

	static private var instance:ColorSampler;

	static public function create(radius:Float, thickness:Float, color:UInt = 0x646464, zoom:Int = 20):ColorSampler {
		if (instance == null)
			instance = new ColorSampler(radius, thickness, color, zoom);
		return instance;
	}

	public function new(radius:Float, thickness:Float, color:UInt = 0x646464, zoom:Int = 20) {
		super();

		this.radius = radius;
		this.mouseEnabled = false;
		this.matrix = new Matrix();

		// pointer
		this.pointer = new Sprite();
		this.addChild(this.pointer);

		this.magnify = new Shape();
		this.magnify.scaleX = this.magnify.scaleY = zoom;
		this.pointer.addChild(this.magnify);

		var overlay = new Shape();
		overlay.graphics.lineStyle(thickness, 0x646464);
		overlay.graphics.drawCircle(0, 0, this.radius);
		overlay.graphics.drawRect(-this.magnify.scaleX * 0.5, -this.magnify.scaleY * 0.5, this.magnify.scaleX, this.magnify.scaleY);
		this.pointer.addChild(overlay);

		this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false, 0, true);
	}

	private function addedToStageHandler(event:Event):Void {
		Mouse.hide();

		// capture screenshot
		if (this.sampleData != null)
			this.sampleData.dispose();
		this.sampleData = new BitmapData(stage.stageWidth, stage.stageHeight, false);
		this.sampleData.draw(stage.root);
		this.move(Math.round(this.stage.mouseX), Math.round(this.stage.mouseY));

		this.stage.addEventListener(MouseEvent.CLICK, this.stage_clickHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		this.move(Math.round(event.stageX), Math.round(event.stageY));
	}

	private function move(x:Int, y:Int):Void {
		this.pointer.x = x;
		this.pointer.y = y;

		this.matrix.tx = -x - 0.5;
		this.matrix.ty = -y - 0.5;
		this.magnify.graphics.clear();
		this.magnify.graphics.beginBitmapFill(this.sampleData, this.matrix, false);
		this.magnify.graphics.drawCircle(0, 0, this.radius / this.magnify.scaleX);
		this.magnify.graphics.endFill();
	}

	private function stage_clickHandler(event:MouseEvent):Void {
		this.stage.removeEventListener(MouseEvent.CLICK, this.stage_clickHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);

		Mouse.show();
		this.stage.removeChild(this);

		this.rgb = this.sampleData.getPixel(Math.round(this.pointer.x), Math.round(this.pointer.y));
		this.sampleData.dispose();
		FeathersEvent.dispatch(this, Event.CHANGE);
	}
}
