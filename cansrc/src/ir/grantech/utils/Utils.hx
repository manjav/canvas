package ir.grantech.utils;

class Utils {
	static public function colorToHEX(red:Int, green:Int, blue:Int, alpha:Int):String {
		var colors = [red, green, blue];
		var hexs = [];
		for (c in colors)
			hexs.push(StringTools.hex(c, 2));
		return hexs.join("");
	}

	static public function normalizeHEX(text:String):String {
		var len:Int = 6 - text.length;
		for (i in 0...len)
			text = "0" + text;
		// len = 8 - text.length;
		// for (i in 0...len)
		// 	text = text + "f";
		return text;
	}

	// static public function hexToRGBA(text:String):RGBA
	// {
	// 	var color:RGBA = new RGBA();
	// 	color.r		= Std.parseInt(text.slice(0,2), 16) / 255;
	// 	color.green	= Std.parseInt(text.slice(2,4), 16) / 255;
	// 	color.b	= Std.parseInt(text.slice(4,6), 16) / 255;
	// 	color.alpha	= Std.parseInt(text.slice(6,8), 16) / 255;
	// 	return color;
	// }
}
