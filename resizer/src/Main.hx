import haxe.Timer;
import bitmap.IOUtil;
import bitmap.PNGBitmap;
import bitmap.transformation.Affine;

class Main {
	static function main() {
		var t = Timer.stamp();

		var bitmap = PNGBitmap.create(IOUtil.readFile("input.png"));
		scale(bitmap, 0.9, 0.9);
		
		trace(Timer.stamp() - t, "Hello, world!");
	}
	
	static function scale(bitmap:PNGBitmap, sx:Float, sy:Float):Void {
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
		IOUtil.writeBitmap('output.png', b);
	}
}
