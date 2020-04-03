package ir.grantech.canvas.utils;

class Utils {

	static public function normalizeHEX(text:String):String {
		var len:Int = 6 - text.length;
		for (i in 0...len)
			text = "0" + text;
		// len = 8 - text.length;
		// for (i in 0...len)
		// 	text = text + "f";
		return text;
	}

	static public function hexToRGBA(text:String):Int {
		var digits = "0123456789ABCDEF";
		var val = 0;
		var hex = text.toUpperCase();
		for (i in 0...hex.length) {
			var d = digits.indexOf(hex.charAt(i));
			val = 16 * val + d;
		}
		return val;
	}
}
