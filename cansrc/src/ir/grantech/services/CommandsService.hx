package ir.grantech.services;

import ir.grantech.canvas.events.CanEvent;
import ir.grantech.services.Layers.Layer;

class CommandsService extends BaseService {
	static public final ADDED:String = "added";
	static public final REMOVED:String = "removed";
	static public final SELECT:String = "select";
	static public final SCALE:String = "scale";
	static public final RESET:String = "reset";

	/**
		The singleton method of CommandsService.
		```hx
		CommandsService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):CommandsService;

	static private function get_instance():CommandsService {
		return BaseService.get(CommandsService);
	}

	private var layers:Layers;
	public function new() {
		super();
		this.layers = new Layers();
	}

	public function commit(command:String, args:Array<Dynamic> = null):Void {
		switch (command){
			case ADDED: this.layers.add(new Layer(args[0]));
			case REMOVED: this.layers.remove(args[0].layer);
		}
		CanEvent.dispatch(this, command, args);
	}
}
