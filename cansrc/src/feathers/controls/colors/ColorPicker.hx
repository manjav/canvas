package feathers.controls.colors;

import openfl.events.Event;
import openfl.events.MouseEvent;
import ir.grantech.canvas.themes.CanTheme;
import openfl.filters.GlowFilter;
import lime.math.RGBA;
import feathers.core.InvalidationFlag;
import feathers.core.FeathersControl;

class ColorPicker extends FeathersControl {

	private var spectrumDisplay:ColorSpectrum;

	@isVar
	public var data(default, set):RGBA = 0xFF;
	private function set_data(value:RGBA):RGBA {
		if (value == this.data)
			return this.data;
		this.data = value;
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	public function new() {
		super();
	}
	override function initialize() {
		this.minWidth = CanTheme.CONTROL_SIZE * 1.5;
		this.minHeight = CanTheme.CONTROL_SIZE;
		super.initialize();
		this.buttonMode = true;
		this.data = 0xFFFF;
		this.filters = [new GlowFilter(0, 1, CanTheme.DEFAULT_PADDING, CanTheme.DEFAULT_PADDING, 2, 2, true)];
		this.addEventListener(MouseEvent.CLICK, this.buttonDisplay_clickHandler);
	}

	private function buttonDisplay_clickHandler(e:Event):Void {
		showSpectrum();
		// this.stage.addEventListener(TouchEvent.TOUCH, this.indicator_touchHandler);
	}

	private function showSpectrum():Void {
		if (this.spectrumDisplay == null) {
			this.spectrumDisplay = new ColorSpectrum();
			this.spectrumDisplay.addEventListener(Event.CHANGE, this.spectrumDisplay_changeHandler);
		}

		var zone = this.getBounds(stage);
		this.spectrumDisplay.y = zone.x + this.width * 0.5;
		this.spectrumDisplay.y = zone.y + 100;
		this.stage.addChild(this.spectrumDisplay);
	}

	private function spectrumDisplay_changeHandler(event:Event):Void {
		this.data = this.spectrumDisplay.data;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			this.graphics.clear();
			this.graphics.beginFill(data);
			this.graphics.drawRoundRect(0, 0, width, height, 14, 14);
		}
		super.update();
	}
}
