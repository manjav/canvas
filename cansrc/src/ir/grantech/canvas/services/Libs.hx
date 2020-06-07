package ir.grantech.canvas.services;

import openfl.display.BitmapData;
import openfl.display.Stage;

class Libs extends BaseService {
	private var map:Map<Int, BitmapData>;
	private var stage:Stage;

	/**
		The singleton method of Libs.
		```hx
		Libs.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Libs;

	static private function get_instance():Libs {
		return BaseService.get(Libs);
	}

	public function new(stage:Stage) {
		super();
		this.stage = stage;
		#if desktop
		this.stage.window.onDropFile.add(this.stage_onDropFileHandler);
	}

	private function stage_onDropFileHandler(path:String):Void {
		commands.layers.open(path);
		#end
	}
}
