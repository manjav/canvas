package ir.grantech.canvas.services;

import haxe.Timer;
import haxe.io.Bytes;
import ir.grantech.canvas.utils.StringUtils;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.net.FileReference;

class Libs extends BaseService {
	// private var map:Map<Int, BitmapData>;
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
			stmp = Timer.stamp() * 1000;
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
		this.read(Bytes.ofData(fr.data), fr.name);
	}

	var stmp = 0.0;

	#if desktop
	public function load(path:String):Void {
		stmp = Timer.stamp() * 1000;
		this.read(sys.io.File.getBytes(path), path);
	}
	#end

	public function read(bytes:Bytes, name:String):Void {
		var t = StringUtils.getExtension(name).toLowerCase();
		trace(t, Timer.stamp() * 1000 - stmp);
		if (t == "webp") {
			// showBMP(webp.Webp.decodeAsBitmapData(bytes));
		} else if (t == "png" || t == "jpg" || t == "jpeg") {
			BitmapData.loadFromBytes(bytes).onComplete(showBMP);
		}
	}
	private function showBMP(bmp:BitmapData):Void {
		trace(Timer.stamp() * 1000 - stmp);
		stage.addChild(new Bitmap(bmp));
	}
}
