package feathers.controls.colors;

import feathers.core.InvalidationFlag;
import feathers.core.PopUpManager;
import feathers.layout.RelativePosition;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGB;
import openfl.Assets;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;

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
		var theme = Std.downcast(Theme.getTheme(), CanTheme);

		super.initialize();
		var icon = new RectangleSkin();
		icon.cornerRadius = CanTheme.DPI * 3;
		icon.border = SolidColor(CanTheme.DPI, theme.textColor);
		icon.fill = Bitmap(Assets.getBitmapData("transparent"));

		this.width = Math.round(CanTheme.CONTROL_SIZE * 0.88);
		this.height = Math.round(CanTheme.CONTROL_SIZE * 0.45);
		backgroundSkin = icon;
		// this.filters = [new GlowFilter(0, 0.5, CanTheme.DPI * 2, CanTheme.DPI * 2, 1, 1, true)];

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
			this.colorDisplay.graphics.drawRoundRect(CanTheme.DPI * 0.5, CanTheme.DPI * 0.5, this.width - CanTheme.DPI, this.height - CanTheme.DPI,
				CanTheme.DPI * 3, CanTheme.DPI * 3);
		}
		super.update();
	}
}
