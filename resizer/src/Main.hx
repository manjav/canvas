import bitmap.Bitmap;
import bitmap.IOUtil;
import bitmap.PNGBitmap;
import bitmap.transformation.Affine;
import haxe.Timer;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class Main {
	static function main() {
		var t = Timer.stamp();

		var srcDir = "origin";
		var dstDir = "C:/_projects/_canvas/cansrc/assets/img/";

		// clear directories
		for (i in 1...5) {
			var d = dstDir + i + "x";
			if (FileSystem.exists(d)) {
				for (f in FileSystem.readDirectory(d))
					FileSystem.deleteFile(haxe.io.Path.join([d, f]));
			} else {
				FileSystem.createDirectory(d);
			}
		}

		// create images
		for (f in FileSystem.readDirectory(srcDir)) {
			var path = haxe.io.Path.join([srcDir, f]);
			try {
				var bitmap = PNGBitmap.create(IOUtil.readFile(path));
				for (i in 1...5) {
					if (i == 4)
						File.copy(path, Path.join([dstDir + "/4x", f]));
					else
						IOUtil.writeBitmap(Path.join([dstDir + i + "x", f]), scale(bitmap, i / 4, i / 4));
				}
			} catch (e:Dynamic) {
				trace(path, e);
			}
		}
		trace(Timer.stamp() - t, "Hello, world!");
	}

	static function scale(bitmap:PNGBitmap, sx:Float, sy:Float):Bitmap {
		if (sx == 1 && sy == 1)
			return bitmap;
		// bitmap.transform.convolve(Convolution.blur(3, 2.7));
		var r = bitmap.transform.affine({affine: new Affine().scale(sx, sy)});
		var w = Math.floor(bitmap.width * sx);
		var h = Math.floor(bitmap.height * sy);
		var b = new PNGBitmap(w, h);
		b.copyFrom(r.bitmap, {x: 0, y: 0}, {
			x: 0,
			y: 0,
			width: w,
			height: h
		});
		return b;
	}
}
