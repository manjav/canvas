package feathers.controls.colors;

import feathers.style.Theme;
import feathers.skins.RectangleSkin;
import lime.math.RGB;
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

class ColorPicker extends LayoutGroup {
	private var colorDisplay:Shape;
	private var callout:ColorCallout;

	public var rgb(default, set):RGB = 0xFFFFFF;

	private function set_rgb(value:RGB):RGB {
		if (value == this.rgb)
			return value;
		this.rgb = value;
		this.setInvalid(InvalidationFlag.DATA);
		return value;
	}

	public var a(default, set):UInt = 0xFF;

	private function set_a(value:UInt):UInt {
		if (this.a == value)
			return value;
		this.a = value;
		this.setInvalid(InvalidationFlag.DATA);
		return value;
	}

	public function new() {
		super();
	}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override function initialize() {
		this.width = CanTheme.CONTROL_SIZE;
		this.height = CanTheme.CONTROL_SIZE * 0.5;
		super.initialize();
		this.buttonMode = true;
		this.graphics.beginBitmapFill(Assets.getBitmapData("transparent"));
		this.graphics.drawRoundRect(0, 0, this.width, this.height, CanTheme.DPI * 2, CanTheme.DPI * 2);
		this.filters = [new GlowFilter(0, 1, CanTheme.DPI * 1.5, CanTheme.DPI * 1.5, 1, 1, true)];

		this.colorDisplay = new Shape();
		this.addChild(this.colorDisplay);

		this.addEventListener(MouseEvent.CLICK, this.buttonDisplay_clickHandler);
	}

	private function buttonDisplay_clickHandler(e:Event):Void {
		this.showCallout();
	}

	public function showCallout():Void {
		if (this.callout == null) {
			this.callout = new ColorCallout();
			this.callout.addEventListener(Event.CHANGE, this.callout_changeHandler);
		}
		this.callout.rgb = this.rgb;

		var fc = new FixableCallout();
		fc.origin = this;
		fc.backgroundSkin = null;
		fc.content = this.callout;
		fc.paddingRight = CanTheme.DEFAULT_PADDING;
		fc.supportedPositions = [RelativePosition.LEFT];
		this.callout.callout = fc;
		PopUpManager.addPopUp(fc, fc.origin, false, false, null);
	}

	private function callout_changeHandler(event:Event):Void {
		this.rgb = this.callout.rgb;
		this.a = this.callout.a;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			this.colorDisplay.graphics.clear();
			this.colorDisplay.graphics.beginFill(this.rgb, this.a / 0xFF);
			this.colorDisplay.graphics.drawRoundRect(0, 0, this.width, this.height, CanTheme.DPI * 2, CanTheme.DPI * 2);
		}
		super.update();
	}
}
