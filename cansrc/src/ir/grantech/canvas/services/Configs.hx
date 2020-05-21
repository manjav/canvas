package ir.grantech.canvas.services;

import openfl.Assets;

class Configs extends BaseService {
	/**
		The singleton method of Configs.
		```hx
		Configs.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Configs;

	static private function get_instance():Configs {
		return BaseService.get(Configs);
	}

	public function new() {
		super();

		Assets.loadText("assets/texts/config.xml").onComplete((text:String) -> {
			text = text.split("\r").join("").split("\n").join("").split("\t").join("");
			var configs = Xml.parse(text).firstElement().elements();
			}
		});
	}
}
