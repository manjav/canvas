package ir.grantech.services;

import openfl.display.Stage;
import openfl.events.Event;

class LayersService extends BaseService {
	/**
		The singleton method of itemsService.
		```hx
		itemsService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):LayersService;

	static private function get_instance():LayersService {
		return BaseService.get(LayersService);
	}

}
