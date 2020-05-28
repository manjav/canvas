package ir.grantech.canvas.services;

import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.utils.AssetType;
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

	public var menuData:Array<Xml>;

	public function new() {
		super();
		var url = "assets/texts/config.xml";
		if (Assets.exists(url, AssetType.TEXT)) {
			if (Assets.isLocal(url, AssetType.TEXT))
				this.parse(Assets.getText(url));
			else
				Assets.loadText(url).onComplete((text:String) -> {
					this.parse(text);
				});
		} else {
			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.load(new URLRequest(url));
		}
	}

	private function loader_completeHandler(event:Event):Void {
		this.parse(cast(event.currentTarget, URLLoader).data);
	}

	@:access(Xml)
	private function parse(text:String):Void {
		text = text.split("\r").join("").split("\n").join("").split("\t").join("");
		var configs = Xml.parse(text).firstElement().elements();
		for (element in configs) {
			trace(element.nodeName, element.nodeType);
			if (element.nodeName == "menu")
				this.menuData = element.children;
		}
	}
}
