package feathers.controls.colors;

import lime.math.RGBA;
import openfl.events.Event;
import openfl.Assets;
import feathers.core.InvalidationFlag;
import feathers.core.FeathersControl;
import lime.math.RGBA;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;

class ColorSpectrum extends FeathersControl {
	private var bitmap:Bitmap;
	private var colorPalette:Bitmap;
	private var bitmapData:BitmapData;

	public var data(default, set):RGBA;

	private function set_data(value:RGBA):RGBA {
		if (this.data == value)
			return this.data;
		this.data = value;
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	public var gap(default, default):Float;

	public var padding(default, default):Float;

	public function new() {
		super();
	}

	override private function initialize():Void {
		super.initialize();
		
		this.bitmapData = Assets.getBitmapData("color_palette");
		this.colorPalette = new Bitmap(this.bitmapData);
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		this.addChild(this.colorPalette);
	}

	private function mouseDownHandler(event:MouseEvent):Void {
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		if(!stage.hasEventListener(MouseEvent.CLICK))
			stage.addEventListener(MouseEvent.CLICK, this.stage_clickHandler);
		this.changeColor(this.bitmapData.getPixel(Math.round(mouseX), Math.round(mouseY)));
	}

	private function mouseMoveHandler(event:MouseEvent):Void {
		this.changeColor(this.bitmapData.getPixel(Math.round(mouseX), Math.round(mouseY)));
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
	}

	private function stage_clickHandler(event:MouseEvent):Void {
		if(Std.is(event.target, ColorSpectrum))
			return;
		stage.removeEventListener(MouseEvent.CLICK, this.stage_clickHandler);
		stage.removeChild(this);
	}

	private function changeColor(color:Int):Void {
		// var a = this.data.a;
		this.data = color;
		// this.data.a = 0xFF;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	// override public function dispose():Void {
	// 	super.dispose();
	// }
}
