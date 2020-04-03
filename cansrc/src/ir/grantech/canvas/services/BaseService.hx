package ir.grantech.canvas.services;

import flash.events.EventDispatcher;

class BaseService extends EventDispatcher {
	static private var classes = new Map<String, Dynamic>();

	static public function get(cl:Class<BaseService>, args:Array<Dynamic> = null):Dynamic {
		if (args == null)
			args = new Array<Dynamic>();
		var name = Std.string(cl);
		if (!classes.exists(name))
			classes.set(name, Type.createInstance(cl, args));
		return classes.get(name);
	}

	public var inputs(get, null):Inputs;

	private function get_inputs():Inputs {
		return Inputs.instance;
	}

	public var assets(get, null):Libs;

	private function get_assets():Libs {
		return Libs.instance;
	}

	public var commands(get, null):Commands;

	private function get_commands():Commands {
		return Commands.instance;
	}
}
