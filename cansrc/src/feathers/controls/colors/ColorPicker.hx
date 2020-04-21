package feathers.controls.colors;

import feathers.core.PopUpManager;
import feathers.core.FeathersControl;
import feathers.core.InvalidationFlag;
import feathers.layout.RelativePosition;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.utils.Utils;
import lime.math.RGBA;
import openfl.Assets;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.GlowFilter;

class ColorPicker extends FeathersControl {
	private var colorDisplay:Shape;
	private var spectrumDisplay:ColorCallout;

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
		this.filters = [new GlowFilter(0, 1, CanTheme.DPI * 1.5, CanTheme.DPI * 1.5, 1, 1, true)];

		this.colorDisplay = new Shape();
		this.addChild(this.colorDisplay);

		this.addEventListener(MouseEvent.CLICK, this.buttonDisplay_clickHandler);
	}

	private function buttonDisplay_clickHandler(e:Event):Void {
		this.showSpectrum();
	}

	public function showSpectrum():Void {
		if (this.spectrumDisplay == null) {
			this.spectrumDisplay = new ColorCallout();
			this.spectrumDisplay.data = data;
			this.spectrumDisplay.addEventListener(Event.CHANGE, this.spectrumDisplay_changeHandler);
		}
		var callout = new FixableCallout();
		callout.origin = this;
		callout.backgroundSkin = null;
		callout.content = this.spectrumDisplay;
		this.spectrumDisplay.callout = callout;
		callout.paddingRight = CanTheme.DEFAULT_PADDING;
		callout.supportedPositions = [RelativePosition.LEFT];
		PopUpManager.addPopUp(callout, callout.origin, false, false, null);
	}

	private function spectrumDisplay_changeHandler(event:Event):Void {
		this.data = this.spectrumDisplay.data;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			this.colorDisplay.graphics.clear();
			this.colorDisplay.graphics.beginFill(Utils.RGBA2RGB(data), data.a / 0xFF);
			this.colorDisplay.graphics.drawRoundRect(0, 0, this.width, this.height, CanTheme.DPI * 2, CanTheme.DPI * 2);
		}
		super.update();
	}
}
