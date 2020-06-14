package ir.grantech.canvas.services;

import feathers.data.ArrayCollection;
import haxe.io.Bytes;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.utils.StringUtils;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.FileReferenceList;

class Libs extends BaseService {
	public var items:ArrayCollection<LibItem>;

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
		this.items = new ArrayCollection<LibItem>();
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

	private function instantiate(name:String):LibItem {
		for (i in 0...this.items.length)
			if (this.items.get(i).name == name)
				return this.items.get(i);

		var item = new LibItem(name);
		this.items.add(item);
		return item;
	}

	@:access(openfl.net.FileReferenceList)
	public function open():Void {
		var fr = new FileReferenceList();
		fr.addEventListener(Event.SELECT, function(event:Event):Void {
			var fr = cast(event.currentTarget, FileReferenceList);
			#if desktop
			for (f in fr.fileList)
				if (new LibItem(f.name).type != LibType.Unknown)
					this.load(f.__path);
			#else
			for (f in fr.fileList) {
				if (new LibItem(f.name).type == LibType.Unknown)
					continue;
				f.addEventListener(Event.COMPLETE, file_openCompleteHandler);
				f.load();
			}
			#end
		});
		fr.browse(#if !desktop [
			new FileFilter("Support files", "*.png;*.jpg;*.jpeg;*.gif;*.mp3"),
			new FileFilter("Sounds files", "*.mp3"),
			new FileFilter("Images files", "*.png;*.jpg;*.jpeg;*.gif")
		] #end);
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
		var item = this.instantiate(name);
		item.data = bytes;
		/* if (item.type == "webp")
				this.addItem(webp.Webp.decodeAsBitmapData(bytes));
			if (item.type == "gif")
				var wrapper = new GifPlayerWrapper(new GifPlayer(GifDecoder.parseBytes(bytes))); */
		if (item.type == LibType.Image)
			BitmapData.loadFromBytes(bytes).onComplete(item.update);
	}
}

enum LibType {
	Unknown;
	Image;
	Sound;
}

class LibItem extends EventDispatcher {
	public var extension(default, set):String;

	private function set_extension(value:String):String {
		if (this.extension == value)
			return value;
		this.extension = value;
		this.type = switch (value) {
			case "mp3": LibType.Sound;
			case "wav": LibType.Sound;
			case "jpg": LibType.Image;
			case "jpeg": LibType.Image;
			case "png": LibType.Image;
			case "gif": LibType.Image;
			default: LibType.Unknown;
		}
		return value;
	}

	public var name(default, set):String;

	private function set_name(value:String):String {
		if (this.name == value)
			return value;
		this.name = value;
		this.extension = StringUtils.getExtension(value).toLowerCase();
		return value;
	}

	public var data:Bytes;
	public var type:LibType;
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
