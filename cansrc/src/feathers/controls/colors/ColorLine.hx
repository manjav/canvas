package feathers.controls.colors;

import lime.math.RGB;
import ir.grantech.canvas.utils.Utils;
import feathers.core.InvalidationFlag;
import feathers.events.FeathersEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGBA;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class ColorLine extends LayoutGroup {
	static public final INVALIDATION_FLAG_COLOR_PICKER_ELEMENT_FACTORY:String = "colorPickerElementFactory";

	private var inputDisplay:TextInput;
	private var pickerDisplay:ColorPicker;

	static private function defaultCallout():ColorCallout {
		return new ColorCallout();
	}

	/* private var _spectrumFactory:Function;
		public function get colorPickerElementFactory():Function
		{
			return this._spectrumFactory;
		}
		public function set colorPickerElementFactory(value:Function):Void
		{
			if( this._spectrumFactory == value )
				return;

			this._spectrumFactory = value;
			this.invalidate(INVALIDATION_FLAG_COLOR_PICKER_ELEMENT_FACTORY);
	}*/
	@isVar
	public var data(default, set):RGB = 0;

	private function set_data(value:RGB):RGB {
		if (value == this.data)
			return this.data;
		this.data = value;
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	override private function initialize():Void {
		super.initialize();
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.verticalAlign = VerticalAlign.JUSTIFY;
		hLayout.gap = 4;
		this.layout = hLayout;

		this.pickerDisplay = new ColorPicker();
		this.pickerDisplay.width = CanTheme.CONTROL_SIZE;
		this.pickerDisplay.rgb = this.data;
		this.pickerDisplay.addEventListener(Event.CHANGE, this.pickerDisplay_changeHandler);
		this.addChild(this.pickerDisplay);
	}

	private function pickerDisplay_changeHandler(event:Event):Void {
		this.data = this.pickerDisplay.rgb;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			if (this.pickerDisplay != null)
				this.pickerDisplay.rgb = this.data;

			if (this.inputDisplay != null)
				this.inputDisplay.text = StringTools.hex(this.data, 2).toLowerCase();
		}
		super.update();
	}
	/* override public function dispose():Void {
		this.pickerDisplay.removeEventListener(Event.TRIGGERED, this.buttonDisplay_triggeredHandler);
		this.spectrumDisplay.removeEventListener(Event.CHANGE, this.spectrumDisplay_changeHandler);
		this.inputDisplay.removeEventListener(FeathersEventType.ENTER, this.inputDisplay_enterHandler);
		super.dispose();
	}*/
}
