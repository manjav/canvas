package ir.grantech.canvas.controls.events;

import openfl.events.Event;

class CanEvent extends Event {
  public var data:Dynamic;
  public function new(type:String, data:Dynamic, bubbles:Bool = false, cancelable:Bool = false) {
    super(type, bubbles, cancelable);
    this.data = data;
  }
}