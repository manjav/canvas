package ir.grantech.canvas.services;

import flash.geom.Matrix;
import haxe.Json;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Input;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Writer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

class Document extends BaseService {
	/**
		The singleton method of Files.
		```hx
		Document.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Document;

	static private function get_instance():Document {
		return BaseService.get(Document);
	}

	var name:String;

	public function openAs():Void {
		this.close();
		var fr = new FileReference();
		fr.addEventListener(Event.SELECT, function(event:Event):Void {
			var fr = cast(event.currentTarget, FileReference);
			fr.addEventListener(Event.COMPLETE, file_openCompleteHandler);
			#if desktop
			this.open(fr.__path);
			#else
			fr.load();
			#end
		});
		fr.browse([new FileFilter("Canvas project files", "*.cvp")]);
	}

	private function file_openCompleteHandler(event:Event):Void {
		var fr = cast(event.currentTarget, FileReference);
		var bytesInput = new BytesInput(Bytes.ofData(fr.data));
		this.read(bytesInput);
		this.name = fr.name;
		Configs.instance.addRecent(this.name);
	}

	#if desktop
	public function open(path:String):Void {
		this.close();
		this.name = path;
		Configs.instance.addRecent(this.name);
		this.read(sys.io.File.read(path));
	}
	#end

	// Use a format.zip.Reader to grab the zip entries
	public function read(input:Input):Void {
		var entries = new Reader(input).read();
		var e = findEntry("manifest.json", entries);
		if (e != null)
			this.loadManifest(unzip(e).toString(), entries);
		// trace(e.fileName, e.compressed, unzip(e).toString());
	}

	private function loadManifest(jsonStr:String, entries:List<Entry>):Void {
		var manifest = Json.parse(jsonStr);
		
		// load assets
		var _assets:Array<String> = manifest.assets;
		for (a in _assets) {
			var e = findEntry("assets/" + a, entries);
			if (e != null)
				libs.read(a, unzip(e));
		}

		// Load layers
		var _layers:Array<Dynamic> = manifest.layers;
		for (l in _layers) {
			// Delete AS3 h field of dictionary
			if (l.h != null)
				l = l.h;
			var layer = new Layer(l.type, l.fillColor, l.fillAlpha, l.borderSize, l.borderColor, l.borderAlpha, l.bounds, l.cornerRadius, l.source);
			commands.layers.add(layer);
			layer.item.transform.matrix = new Matrix(l.mat[0], l.mat[1], l.mat[2], l.mat[3], l.mat[4], l.mat[5]);
			layer.item.alpha = l.alpha;
			layer.item.blendMode = l.blendMode;
			CanEvent.dispatch(commands, Commands.ADDED, [layer.item]);
		}
	}

	public function save(saveAs:Bool):Void {
		#if !desktop
		if (!saveAs)
			saveAs = true;
		#end

		// First saving recognition
		if (this.name == null)
			saveAs = true;

		// Create manifest
		var now = Date.now();
		// Create a list of entries
		var entries:List<Entry> = new List();

		// Save assets
		var _assets = new Array<String>();
		for (l in libs.items.array) {
			_assets.push(l.name);
			entries.add(createEntry("assets/" + l.name, now, l.data));
		}

		// Save layers
		var _layers = new Array<Dynamic>();
		for (l in commands.layers.array)
			_layers.push(l.getProperties());
		// Convert the string to bytes
		entries.add(createEntry("manifest.json", now, Bytes.ofString(Json.stringify({assets: _assets, layers: _layers}))));

		// Write our entries to a BytesOutput stream using format.zip.Writer
		var bytesOutput = new BytesOutput();
		var writer = new Writer(bytesOutput);
		writer.write(entries);

		// Save
		var byteArray:ByteArray;
		var data = bytesOutput.getBytes().getData();
		#if cpp
		// Convert UInt8 to byte
		byteArray = new ByteArray();
		for (i in data)
			byteArray.writeByte(i);

		if (!saveAs) {
			sys.io.File.saveBytes(this.name, byteArray);
			return;
		}
		#else
		byteArray = data;
		#end

		// Save as the zipped file to disc
		var fr = new FileReference();
		fr.addEventListener(Event.SELECT, this.file_saveCompleteHandler);
		fr.save(byteArray, this.name == null ? "New Project.cvp" : this.name);
	}

	private function file_saveCompleteHandler(event:Event) {
		var fr = cast(event.currentTarget, FileReference);
		#if desktop
		this.name = fr.__path;
		#else
		this.name = fr.name;
		#end
		Configs.instance.addRecent(this.name);
	}

	public function close():Void {
		this.name = null;
		libs.items.removeAll();
		commands.layers.removeAll();
		CanEvent.dispatch(commands, Commands.REMOVED);
	}

	// Create a zip entry for the bytes:
	public static function findEntry(name:String, entries:List<Entry>):Entry {
		for (e in entries)
			if (e.fileName == name)
				return e;
		return null;
	}

	// Create a zip entry for the bytes:
	public static function createEntry(name:String, time:Date, bytes:Bytes):Entry {
		var entry:Entry = {
			fileName: name, // <- This is the internal zip file folder structure
			fileSize: bytes.length,
			fileTime: time,
			compressed: false,
			dataSize: 0,
			data: bytes,
			crc32: Crc32.make(bytes)
		}
		return entry;
	}

	public static function unzip(f:Entry) {
		if (!f.compressed)
			return f.data;
		#if !hl
		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(f.fileSize);
		var r = c.execute(f.data, 0, s, 0);
		c.close();
		if (!r.done || r.read != f.data.length || r.write != f.fileSize)
			throw "Invalid compressed data for " + f.fileName;
		f.compressed = false;
		f.dataSize = f.fileSize;
		f.data = s;
		#end
		return f.data;
	}
}
