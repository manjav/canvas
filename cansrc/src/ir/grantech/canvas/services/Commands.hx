package ir.grantech.canvas.services;

import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Layers.Layer;

class Commands extends BaseService {
	static public final ADDED:String = "added";
	static public final REMOVED:String = "removed";
	static public final SELECT:String = "select";
	static public final ROTATE:String = "rotate";
	static public final SCALE:String = "scale";
	static public final ENABLE:String = "enable";
	static public final VISIBLE:String = "visible";
	static public final RESET:String = "reset";

	/**
		The singleton method of Commands.
		```hx
		Commands.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Commands;

	static private function get_instance():Commands {
		return BaseService.get(Commands);
	}

	private var layers:Layers;

	public function new() {
		super();
		this.layers = new Layers();
	}

	public function commit(command:String, args:Array<Dynamic> = null):Void {
		switch (command) {
			case ADDED:
				this.layers.add(new Layer(args[0]));
			case REMOVED:
				var items = cast(args[0], CanItems).items;
				for (i in items)
					this.layers.remove(i.layer);
		}
		CanEvent.dispatch(this, command, args);
	}
}
