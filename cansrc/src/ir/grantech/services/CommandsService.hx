package ir.grantech.services;

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

}
