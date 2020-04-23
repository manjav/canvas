package feathers.controls.colors;

import feathers.core.InvalidationFlag;
import feathers.events.FeathersEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGB;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;

class ColorLine extends LayoutGroup implements IToggle {
	/**
		Indicates if the color set is enabled or not. The button may be selected
		programmatically, even if `toggleable` is `false`, but generally,
		`toggleable` should be set to `true` to allow the user to select and
		deselect it by triggering the button with a click or tap. If focus
		management is enabled, and the button has focus, a button may also be
		triggered with the spacebar.

		**Warning:** Do not listen for `TriggerEvent.TRIGGER` to be notified
		when the `selected` property changes. You must listen for
		`Event.CHANGE`, which is dispatched after `TriggerEvent.TRIGGER`.

		@default false

		@see `BasicToggleButton.toggleable`

		@since 1.0.0
	**/
	@:isVar
	public var selected(get, set):Bool = false;

	private function get_selected():Bool {
		return this.selected;
	}

	private function set_selected(value:Bool):Bool {
		if (this.selected == value)
			return value;

		this.selected = value;
		FeathersEvent.dispatch(this, Event.SELECT);
		this.setInvalid(InvalidationFlag.SELECTION);
		return value;
	}

	public var hasAlpha(default, set):Bool = true;

	private function set_hasAlpha(value:Bool):Bool {
		if (this.hasAlpha == value)
			return value;

		this.hasAlpha = value;
		if (this.pickerDisplay != null)
			this.pickerDisplay.hasAlpha = value;
		return value;
	}

	private var checkBox:Check;
	private var labelDisplay:Label;
	private var samplerButton:Button;
	private var pickerDisplay:ColorPicker;

	static private function defaultCallout():ColorCallout {
		return new ColorCallout();
	}

	public var label(default, set):String = "Label";

	private function set_label(value:String):String {
		if (this.label == value)
			return value;
		this.label = value;
		if (this.labelDisplay != null)
			this.labelDisplay.text = value;
		return value;
	}

	public var rgb(default, set):RGB = 0;

	private function set_rgb(value:RGB):RGB {
		if (this.rgb == value)
			return value;
		this.rgb = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		this.setInvalid(InvalidationFlag.DATA);
		return value;
	}

	public var a(default, set):UInt = 0xFF;

	private function set_a(value:UInt):UInt {
		if (this.a == value)
			return value;
		this.a = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		this.setInvalid(InvalidationFlag.DATA);
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.layout = new AnchorLayout();
		var padding = CanTheme.DEFAULT_PADDING;

		this.checkBox = new Check();
		this.checkBox.width = CanTheme.CONTROL_SIZE;
		this.checkBox.paddingLeft = 0;
		this.checkBox.paddingRight = 0;
		this.checkBox.selected = this.selected;
		this.checkBox.layoutData = AnchorLayoutData.middleLeft(0, -padding * 0.5);
		this.checkBox.addEventListener(Event.CHANGE, this.checkBox_changeHandler);
		this.addChild(this.checkBox);

		this.pickerDisplay = new ColorPicker();
		this.pickerDisplay.width = CanTheme.CONTROL_SIZE;
		this.pickerDisplay.hasAlpha = this.hasAlpha;
		this.pickerDisplay.rgb = this.rgb;
		this.pickerDisplay.a = this.a;
		this.pickerDisplay.addEventListener(Event.CHANGE, this.pickerDisplay_changeHandler);
		this.pickerDisplay.layoutData = AnchorLayoutData.middleLeft(0, padding * 2);
		this.addChild(this.pickerDisplay);

		this.labelDisplay = new Label();
		this.labelDisplay.embedFonts = true;
		this.labelDisplay.text = this.label;
		// this.labelDisplay.variant = Label.VARIANT_HEADING;
		this.labelDisplay.layoutData = AnchorLayoutData.middleLeft(0, padding * 5);
		this.addChild(this.labelDisplay);

		this.samplerButton = new Button();
		this.samplerButton.icon = new Bitmap(Assets.getBitmapData("sampler"));
		this.samplerButton.addEventListener(MouseEvent.CLICK, this.samplerButtonClickHandler);
		this.samplerButton.layoutData = AnchorLayoutData.middleRight(0, -padding);
		this.addChild(this.samplerButton);
	}

	private function checkBox_changeHandler(event:Event):Void {
		this.selected = checkBox.selected;
	}

	private function samplerButtonClickHandler(event:MouseEvent):Void {
		event.stopImmediatePropagation();
		var sampler = ColorSampler.create(CanTheme.DPI * 30, CanTheme.DPI * 0.5);
		sampler.addEventListener(Event.CHANGE, this.sampler_changeHandler);
		this.stage.addChild(sampler);
	}

	private function sampler_changeHandler(event:Event):Void {
		var sampler = cast(event.currentTarget, ColorSampler);
		sampler.removeEventListener(Event.CHANGE, this.sampler_changeHandler);
		this.rgb = sampler.rgb;
	}

	private function pickerDisplay_changeHandler(event:Event):Void {
		this.rgb = this.pickerDisplay.rgb;
		this.a = this.pickerDisplay.a;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.SELECTION))
			this.checkBox.selected = this.selected;

		if (this.isInvalid(InvalidationFlag.DATA)) {
			this.pickerDisplay.rgb = this.rgb;
			this.pickerDisplay.a = this.a;
		}

		super.update();
	}
}
