package feathers.controls;

import feathers.core.InvalidationFlag;
import feathers.events.FeathersEvent;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

class CanTextInput extends TextInput implements IRange {
	private var stepY = 0.0;
	private var speed = 0.1;

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
		this.set_text(Std.string(this.value));
		this.setInvalid(InvalidationFlag.DATA);
		FeathersEvent.dispatch(this, Event.CHANGE);

		return this.value;
	}

	/**
		The step for changes.

		The following example sets the range of acceptable values:

		```hx
		range.min = 0.01;
		range.maximum = 100.0;
		```

		@since 1.0.0
	**/
	@:isVar
	public var step(get, set):Float = 1;

	private function get_step():Float {
		return this.step;
	}

	private function set_step(step:Float):Float {
		if (step < 0.01)
			step = 0.01;
		if (this.step == step)
			return this.step;
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
		return this.maximum = maximum;
	}

	override private function textField_changeHandler(event:Event):Void {
		// don't let this event bubble. Feathers UI components don't bubble their
		// events — especially not Event.CHANGE!
		event.stopPropagation();

		// no need to invalidate here. just store the new text.
		@:bypassAccessor this.text = this.textField.text;
		// but the event still needs to be dispatched
		this.value = Std.parseFloat(this.textField.text);
	}

	override private function textField_focusInHandler(event:FocusEvent):Void {
		super.textField_focusInHandler(event);
		this.stepY = mouseY;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
	}

	override private function textField_focusOutHandler(event:FocusEvent):Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		super.textField_focusOutHandler(event);
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		if (!event.buttonDown)
			return;
		var speed = this.speed * (event.shiftKey ? 3 : 1);
		var delta = (this.stepY - this.mouseY) * speed;
		var diff = Math.abs(delta) - this.step;
		if (diff > 0) {
			this.value += this.step * (delta / Math.abs(delta));
			this.stepY = mouseY - diff * (delta / Math.abs(delta)) / speed;
			// trace(value, this.stepY - mouseY);
		}
	}
}
