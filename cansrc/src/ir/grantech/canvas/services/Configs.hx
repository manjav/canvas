package ir.grantech.canvas.services;

import openfl.net.SharedObject;
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

	public var menuData:Array<Config>;
	public var recentFiles:Array<String>;

	public function new() {
		super();
		this.loadPrefs();
		this.loadConfigs();
	}

	
	private function loadPrefs():Void {
		var so = SharedObject.getLocal("prefs");
		if(so.data.recentFiles == null)
			return;
		this.recentFiles = so.data.recentFiles;
	}

	
	private function savePrefs():Void {
		var so = SharedObject.getLocal("prefs");
		so.data.recentFiles = this.recentFiles;
		so.flush();
	}

	private function loadConfigs():Void {
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
		this.menuData = new Array<Config>();
		var configs = Xml.parse(text).firstElement().elements();
		for (element in configs)
			if (element.nodeName == "menu")
				for (m in element.children)
					if (Type.enumEq(m.nodeType, XmlType.Element))
						this.menuData.push(new Config().init(m));
		this.loadPrefs();
	}
}

class Config {
	public var isDivider:Bool;
	public var name:String;
	public var path:String;
	public var shortKey:String;
	public var children:Array<Config>;

	public function new(?name:String, ?path:String) {
		this.children = new Array<Config>();
		this.name = name;
		this.path = path;
		}

	@:access(Xml)
	public function init(xml:Xml):Config {
		if (this.isDivider = xml.nodeName == "divider")
			return this;
		this.name = xml.attributeMap["name"];
		this.path = xml.attributeMap["path"];
		this.shortKey = xml.attributeMap["shortKey"];
		this.children = new Array<Config>();
		for (c in xml.children)
			this.children.push(new Config().init(c));
		return this;
	}
}
