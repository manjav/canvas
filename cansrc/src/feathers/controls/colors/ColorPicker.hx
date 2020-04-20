package feathers.controls.colors;

import feathers.core.FeathersControl;
import feathers.core.InvalidationFlag;
import feathers.layout.RelativePosition;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.GlowFilter;

class ColorPicker extends FeathersControl {
	private var colorDisplay:Shape;
	private var spectrumDisplay:ColorPopup;

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
		this.width = CanTheme.CONTROL_SIZE;
		this.height = CanTheme.CONTROL_SIZE * 0.5;
		super.initialize();
		this.buttonMode = true;
		this.graphics.beginBitmapFill(Assets.getBitmapData("transparent"));
		this.graphics.drawRoundRect(0, 0, this.width, this.height, CanTheme.DPI * 2, CanTheme.DPI * 2);
		this.data = 0xFF;
		this.filters = [new GlowFilter(0, 1, CanTheme.DPI, CanTheme.DPI, 1, 1, true)];

		this.colorDisplay = new Shape();
		this.addChild(this.colorDisplay);

		this.addEventListener(MouseEvent.CLICK, this.buttonDisplay_clickHandler);
	}

	private function buttonDisplay_clickHandler(e:Event):Void {
		this.showSpectrum();
	}

	public function showSpectrum():Void {
		if (this.spectrumDisplay == null) {
			this.spectrumDisplay = new ColorPopup();
			this.spectrumDisplay.addEventListener(Event.CHANGE, this.spectrumDisplay_changeHandler);
		}
		Callout.show(this.spectrumDisplay, this, [RelativePosition.LEFT]);
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
			this.graphics.drawRoundRect(0, 0, this.width, this.height, CanTheme.CONTROL_SIZE * 0.3, CanTheme.CONTROL_SIZE * 0.3);
		}
		super.update();
	}
}
