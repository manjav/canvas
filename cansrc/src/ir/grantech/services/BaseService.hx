package ir.grantech.services;

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

	public var inputs(get, null):InputService;

	private function get_inputs():InputService {
		return InputService.instance;
	}

	public var assets(get, null):AssetsService;

	private function get_assets():AssetsService {
		return AssetsService.instance;
	}

	public var commands(get, null):CommandsService;

	private function get_commands():CommandsService {
		return CommandsService.instance;
	}
}
