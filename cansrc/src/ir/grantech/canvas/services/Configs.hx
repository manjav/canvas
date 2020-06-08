package ir.grantech.canvas.services;

import Xml.XmlType;
import openfl.Assets;
import openfl.events.Event;
import openfl.net.SharedObject;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.AssetType;

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


	public var recents(default, set):Array<String>;

	private function set_recents(value:Array<String>):Array<String> {
		if (value == this.recents)
			return value;
		if (this.menuData == null)
			return value;
		var recent = this.findItem("Open Recents");
		recent.children = new Array<Config>();
		for (r in value) {
			var s = r.split("\\");
			recent.children.push(new Config(s[s.length - 1], r));
		}
		this.recents = value;
		return value;
	}

	public function new() {
		super();
		this.loadConfigs();
	}

	public function loadPrefs():Void {
		var so = SharedObject.getLocal("prefs");
		if (so.data.recents != null)
			this.recents = so.data.recents;
	}

	public function savePrefs():Void {
		var so = SharedObject.getLocal("prefs");
		so.data.recents = this.recents;
		so.flush();
	}

	public function addRecent(path:String):Void {
		var r = this.recents;
		if (r == null)
			r = new Array<String>();
		if (r.indexOf(path) == -1)
			r.push(path);
		this.recents = r;
		this.savePrefs();
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

	private function findItem(name:String, parent:Array<Config> = null):Config {
		if (parent == null)
			parent = this.menuData;
		for (m in parent)
			if (m.name == name)
				return m;
			else if (m.children.length > 0)
				return this.findItem(name, m.children);
		return null;
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
