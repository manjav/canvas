package ir.grantech.canvas.services;

import haxe.io.Bytes;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.utils.StringUtils;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.net.FileFilter;
import openfl.net.FileReference;

class Libs extends BaseService {
	private var map:Map<String, LibItem>;
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
		this.map = new Map<String, LibItem>();
		this.stage = stage;
		#if desktop
		this.stage.window.onDropFile.add(this.stage_onDropFileHandler);
		#end
	}

	#if desktop
	private function stage_onDropFileHandler(path:String):Void {
		if (StringUtils.getExtension(path) == "cvp")
			commands.layers.open(path);
		else
			this.load(path);
	}
	#end

	public function open():Void {
		var fr = new FileReference();
		fr.addEventListener(Event.SELECT, function(event:Event):Void {
			var fr = cast(event.currentTarget, FileReference);
			fr.addEventListener(Event.COMPLETE, file_openCompleteHandler);
			#if desktop
			this.load(fr.__path);
			#else
			fr.load();
			#end
		});
		fr.browse([
			new FileFilter("Support files", "*.png;*.jpg;*.jpeg;*.gif;*.mp3"),
			new FileFilter("Sounds files", "*.mp3"),
			new FileFilter("Images files", "*.png;*.jpg;*.jpeg;*.gif")
		]);
	}

	private function file_openCompleteHandler(event:Event):Void {
		var fr = cast(event.currentTarget, FileReference);
		this.read(fr.name, Bytes.ofData(fr.data));
	}

	#if desktop
	public function load(path:String):Void {
		this.read(path, sys.io.File.getBytes(path));
	}
	#end

	public function read(name:String, bytes:Bytes):Void {
		var s = name.split("\\");
		name = s[s.length - 1];
		var item = map.exists(name) ? map.get(name) : new LibItem(name);
		item.type = StringUtils.getExtension(name);
		item.data = bytes;
		map.set(name, item);
		if (item.type == "png" || item.type == "jpg" || item.type == "jpeg" || item.type == "gif") {
			BitmapData.loadFromBytes(bytes).onComplete(item.update);
		}
		}
	}

class LibItem extends EventDispatcher {
	public var data:Bytes;
	public var name:String;
	public var type:String;
	public var source:Dynamic;

	public function new(name:String) {
		super();
		this.name = name;
	}

	public function update(source:Dynamic):Void {
		this.source = source;
		CanEvent.dispatch(this, Event.CHANGE);
	}
}
