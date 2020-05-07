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

	static public function hexToDecimal(text:String):UInt {
		var digits = "0123456789ABCDEF";
		var val = 0;
		var hex = text.toUpperCase();
		for (i in 0...hex.length) {
			var d = digits.indexOf(hex.charAt(i));
			val = 16 * val + d;
		}
		return val;
	}

	//   static public function normalizeHEX(text:String):String
	// 	{
	// 		var len:int = 6 - text.length;
	// 		for( var i:int = 0; i < len; i++ )
	// 			text = "0" + text;
	// 		len = 8 - text.length;
	// 		for( i = 0; i < len; i++ )
	// 			text = text + "f";
	// 		return text;
	// 	}

	static public function getExtension(path:String):String {
		var cp = path.lastIndexOf(".");
		if (cp != -1)
			return path.substr(cp + 1);
		return null;
	}

	static 	public function round(value:Float, border:Int = 32):Float {
		return Math.round(value / border) * border;
	}
}
