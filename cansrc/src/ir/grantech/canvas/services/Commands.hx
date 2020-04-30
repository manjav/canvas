package ir.grantech.canvas.services;

import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Layers.Layer;

class Commands extends BaseService {
	static public final ADDED:String = "added";
	static public final REMOVED:String = "removed";
	static public final SELECT:String = "select";
	static public final TRANSLATE:String = "translate";
	static public final SCALE:String = "scale";
	static public final ROTATE:String = "rotate";
	static public final RESIZE:String = "resize";
	static public final BLEND_MODE:String = "blendMode";
	static public final ALPHA:String = "alpha";
	static public final ENABLE:String = "enable";
	static public final VISIBLE:String = "visible";
	static public final RESET:String = "reset";
	static public final ORDER:String = "order";
	static public final ALIGN:String = "align";

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
				var layer = new Layer(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				this.layers.add(layer);
				args = [layer.item];
			case REMOVED:
				var items = cast(args[0], CanItems).items;
				for (i in items)
					this.layers.remove(i.layer);
			case ORDER:
				this.layers.changeOrder(args[0], args[1]);
				args[2] = this.layers;
		}
		CanEvent.dispatch(this, command, args);
	}
}
