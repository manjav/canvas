package ir.grantech.services;

import openfl.display.Stage;
import openfl.display.BitmapData;

class AssetsService extends BaseService {
	private var map:Map<Int, BitmapData>;
	private var stage:Stage;

	/**
		The singleton method of AssetsService.
		```hx
		AssetsService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):AssetsService;

	static private function get_instance():AssetsService {
		return BaseService.get(AssetsService);
	}

	public function new(stage:Stage) {
		super();
		this.stage = stage;
		this.stage.window.onDropFile.add(this.stage_onDropFileHandler);
	}

	private function stage_onDropFileHandler(path:String):Void {
		trace(path);
	}
}
