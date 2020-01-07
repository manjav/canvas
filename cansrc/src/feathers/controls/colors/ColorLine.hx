package feathers.controls.colors;

import ir.grantech.canvas.themes.CanTheme;
import feathers.core.InvalidationFlag;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;
import lime.math.RGBA;
import openfl.events.Event;
import openfl.events.MouseEvent;

class ColorLine extends LayoutGroup {
	static public final INVALIDATION_FLAG_COLOR_PICKER_ELEMENT_FACTORY:String = "colorPickerElementFactory";
	
	private var inputDisplay:TextInput;
	private var pickerDisplay:ColorPicker;

	static private function defaultSpctrumFactory():ColorSpectrum {
		return new ColorSpectrum();
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
	public var data(default, set):RGBA = 0xFF;

	private function set_data(value:RGBA):RGBA {
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
		this.pickerDisplay.data = this.data;
		this.pickerDisplay.addEventListener(Event.CHANGE, this.pickerDisplay_changeHandler);
		this.addChild(this.pickerDisplay);

		var textLayout:LayoutGroup = new LayoutGroup();
		textLayout.layout = new AnchorLayout();
		textLayout.layoutData = new HorizontalLayoutData(100);
		this.addChild(textLayout);

		this.inputDisplay = new TextInput();
		this.inputDisplay.paddingLeft = 16;
		this.inputDisplay.paddingRight = 6;
		// this.inputDisplay.maxChars = 8;
		this.inputDisplay.restrict = "0-9a-fA-F";
		// this.inputDisplay.addEventListener(FeathersEventType.ENTER, this.inputDisplay_enterHandler);
		// this.inputDisplay.addEventListener(FeathersEventType.FOCUS_OUT, this.inputDisplay_enterHandler);
		this.inputDisplay.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		textLayout.addChild(this.inputDisplay);

		var numSignDisplay:Label = new Label();
		numSignDisplay.layoutData = new AnchorLayoutData(null, null, null, 6, null, 0);
		numSignDisplay.mouseEnabled = false;
		numSignDisplay.text = "#";
		textLayout.addChild(numSignDisplay);
	}

	private function pickerDisplay_changeHandler(e:Event):Void {
		this.data = this.pickerDisplay.data;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
	}

	private function inputDisplay_enterHandler(e:Event):Void {
		// var hexText:String = Utils.normalizeHEX(this.inputDisplay.text);
		// this.inputDisplay.text = hexText;
		// this.data = Utils.hexToRGBA(hexText);
		// this.dispatchEventWith(Event.CHANGE, false, this.data);
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			if (this.pickerDisplay != null)
				this.pickerDisplay.data = this.data;
			trace(this.data, this.pickerDisplay.data);

			if (this.inputDisplay != null)
				this.inputDisplay.text = this.data + "33"; // Utils.colorToHEX(this.data.red, this.data.green, this.data.blue, this.data.alpha);
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
