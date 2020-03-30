package feathers.controls;

import ir.grantech.canvas.themes.CanTheme;
import feathers.events.FeathersEvent;
import openfl.events.Event;
import feathers.core.InvalidationFlag;
import feathers.core.FeathersControl;
import feathers.controls.IRange;

class CanHSlider extends FeathersControl implements IRange {
	/**
		The step for changes.

		The following example sets the range of acceptable values:

		```hx
		range.min = 0.01;
		range.maximum = 100.0;
		```

		@since 1.0.0
	**/
	public var step(default, set):Float = 1.0;

	private function set_step(step:Float):Float {
		if (step < 0.01)
			step = 0.01;
		if (this.step == step)
			return this.step;
		if (this.sliderDisplay != null)
			this.sliderDisplay.step = step;
		if (this.inputDisplay != null)
			this.inputDisplay.step = step;
		return this.step = step;
	}

	/**
		The minimum numeric value of the range.

		The following example sets the range of acceptable values:

		```hx
		range.minimum = 0.01;
		range.maximum = Math.POSITIVE_INFINITY;
		```

		@since 1.0.0
	**/
	@:isVar
	public var minimum(get, set):Float = Math.NEGATIVE_INFINITY;

	private function get_minimum():Float {
		return this.minimum;
	}

	private function set_minimum(minimum:Float):Float {
		if (this.minimum == minimum)
			return this.minimum;
		if (this.sliderDisplay != null)
			this.sliderDisplay.minimum = minimum;
		if (this.inputDisplay != null)
			this.inputDisplay.minimum = minimum;
		return this.minimum = minimum;
	}

	/**
		The maximum numeric value of the range.

		The following example sets the range of acceptable values and updates
		the current value:

		```hx
		range.minimum = Math.NEGATIVE_INFINITY;
		range.maximum = Math.POSITIVE_INFINITY;
		range.value = 50.0;
		```

		@since 1.0.0
	**/
	@:isVar
	public var maximum(get, set):Float = Math.POSITIVE_INFINITY;

	private function get_maximum():Float {
		return this.maximum;
	}

	private function set_maximum(maximum:Float):Float {
		if (this.maximum == maximum)
			return this.maximum;
		if (this.sliderDisplay != null)
			this.sliderDisplay.maximum = maximum;
		if (this.inputDisplay != null)
			this.inputDisplay.maximum = maximum;
		return this.maximum = maximum;
	}

	/**
		The current numeric value of the range.
		The following example sets the range of acceptable values:

		```hx
		range.minimum = 0.0;
		range.maximum = 100.0;
		```

		@since 1.0.0
	**/
	@:isVar
	public var value(get, set):Float = 0;

	private function get_value():Float {
		return this.value;
	}

	private function set_value(value:Float):Float {
		if (this.minimum > value)
			value = this.minimum;
		if (this.maximum < value)
			value = this.maximum;
		if (this.value == value)
			return this.value;

		this.value = value;
		this.setInvalid(InvalidationFlag.DATA);
		FeathersEvent.dispatch(this, Event.CHANGE);

		return this.value;
	}

	override private function set_enabled(value:Bool):Bool {
		if (super.enabled == value)
			return super.enabled;

		if (this.sliderDisplay != null)
			this.sliderDisplay.mouseEnabled = this.sliderDisplay.enabled = value;
		if (this.inputDisplay != null)
			this.inputDisplay.enabled = value;

		return super.enabled = value;
	}

	private var sliderDisplay:HSlider;
	private var inputDisplay:CanRangeInput;

	private function createElements():Void {
		if (this.sliderDisplay == null) {
			this.sliderDisplay = new HSlider();
			this.sliderDisplay.minimum = this.minimum;
			this.sliderDisplay.maximum = this.maximum;
			this.sliderDisplay.step = step;
			this.addChild(this.sliderDisplay);
		}

		if (this.inputDisplay == null) {
			this.inputDisplay = new CanRangeInput();
			this.inputDisplay.step = this.step;
			this.inputDisplay.minimum = this.minimum;
			this.inputDisplay.maximum = this.maximum;
			this.inputDisplay.width = CanTheme.CONTROL_SIZE * 2;
			this.inputDisplay.valueFormatter = (v:Float) -> {
				return Std.string(Math.round(value));
			};
			this.addChild(this.inputDisplay);
		}

		this.sliderDisplay.removeEventListener(Event.CHANGE, this.displays_changeHandler);
		this.inputDisplay.removeEventListener(Event.CHANGE, this.displays_changeHandler);
		this.sliderDisplay.value = this.value;
		this.inputDisplay.value = this.value;
		this.sliderDisplay.addEventListener(Event.CHANGE, this.displays_changeHandler);
		this.inputDisplay.addEventListener(Event.CHANGE, this.displays_changeHandler);
	}

	private function displays_changeHandler(event:Event):Void {
		this.value = cast(event.currentTarget, IRange).value;
	}

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA))
			this.createElements();

		if (this.isInvalid(InvalidationFlag.SIZE))
			this.layoutContent();
	}

	private function layoutContent():Void {
		this.inputDisplay.x = this.actualWidth - this.inputDisplay.width;
		this.inputDisplay.height = this.actualHeight;
		this.sliderDisplay.height = this.actualHeight;
		this.sliderDisplay.width = this.inputDisplay.x - CanTheme.DEFAULT_PADDING;
	}
}
