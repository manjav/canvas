package ir.grantech.services;

import openfl.events.KeyboardEvent;
import openfl.display.Stage;

class KeyBoardService extends BaseService {
	public var spaceBarDown = false;
	private var stage:Stage;

	/**
		The singleton method of KeyBoardService.
		```hx
		KeyBoardService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):KeyBoardService;

	static private function get_instance():KeyBoardService {
		return BaseService.get(KeyBoardService);
	}

	public function new(stage:Stage) {
		this.stage = stage;
		this.stage.addEventListener(KeyboardEvent.KEY_UP, this.this_keyboardHandler);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.this_keyboardHandler);
	}

	private function this_keyboardHandler(event:KeyboardEvent):Void {
		if (event.keyCode != 32) // is not space bar
			return;
		this.spaceBarDown = event.type == KeyboardEvent.KEY_DOWN;
	}
}
