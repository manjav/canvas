package ir.grantech.canvas.events;

import lime.utils.ObjectPool;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

class CanEvent extends Event {
	private static var _pool = new ObjectPool<CanEvent>(() -> return new CanEvent(null, null, false, false));

	/**
		Dispatches a pooled event with the specified properties.

		```hx
		CanEvent.dispatch(component, Event.CHANGE);
		```

		@since 1.0.0
	**/
	public static function dispatch(dispatcher:IEventDispatcher, type:String, data:Dynamic = null, bubbles:Bool = false, cancelable:Bool = false):Bool {
		#if flash
		var event = new CanEvent(type, data, bubbles, cancelable);
		return dispatcher.dispatchEvent(event);
		#else
		var event = _pool.get();
		event.type = type;
		event.data = data;
		event.bubbles = bubbles;
		event.cancelable = cancelable;
		var result = dispatcher.dispatchEvent(event);
		_pool.release(event);
		return result;
		#end
	}

	public var data:Dynamic;

	/**
		Creates a new `CanEvent` object with the given arguments.

		@see `CanEvent.dispatch`

		@since 1.0.0
	**/
	public function new(type:String, data:Dynamic = null, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
		this.data = data;
	}

	override public function clone():Event {
		return new CanEvent(this.type, this.data, this.bubbles, this.cancelable);
	}
}