package ir.grantech.canvas.utils;

import lime.math.RGBA;

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

	static public function hexToRGBA(text:String):UInt {
		var digits = "0123456789ABCDEF";
		var val = 0;
		var hex = text.toUpperCase();
		for (i in 0...hex.length) {
			var d = digits.indexOf(hex.charAt(i));
			val = 16 * val + d;
		}
		return val;
	}

	/**
	 * Converts HSV values to RGB values.
	 * @param h: A uint from 0 to 360 representing the hue value.
	 * @param s: A uint from 0 to 100 representing the saturation value.
	 * @param v: A uint from 0 to 100 representing the lightness value.
	 * @return Returns an object with the properties r, g, and b defined.
	 */
	static public function HSVAtoRGBA(h:Float, s:Float, v:Float, a:Float):RGBA {
		var rgba:RGBA = new RGBA(),

			tempS:Float = s / 100,
			tempV:Float = v / 100,

			hi:Int = Math.floor(h / 60) % 6,
			f:Float = h / 60 - Math.floor(h / 60),
			p:Float = (tempV * (1 - tempS)),
			q:Float = (tempV * (1 - f * tempS)),
			t:Float = (tempV * (1 - (1 - f) * tempS));

		var rates = switch (hi) {
			case 0:
				[tempV, t, p];
			case 1:
				[q, tempV, p];
			case 2:
				[p, tempV, t];
			case 3:
				[q, p, tempV];
			case 4:
				[t, p, tempV];
			default:
				[tempV, p, q];
		}

		rgba.set(Math.round(rates[0] * 0xFF), Math.round(rates[1] * 0xFF), Math.round(rates[2] * 0xFF), Math.round(a * 0xFF));
		return rgba;
	}

	/**
	 * Converts RGB values to HSV values.
	 * @param r: A uint from 0 to 255 representing the red color value.
	 * @param g: A uint from 0 to 255 representing the green color value.
	 * @param b: A uint from 0 to 255 representing the blue color value.
	 * @return Returns an object with the properties h, s, and v defined.
	 */
	public static function RGBtoHSV(r:Float, g:Float, b:Float):Array<UInt> {
		var max:Float = Math.max(r, g);
		max = Math.max(max, b);

		var min:Float = Math.min(r, g);
		min = Math.min(min, b);

		var hue:Float = 0;
		var saturation:Float = 0;
		var value:Float = 0;

		// get Hue
		if (max == min)
			hue = 0;
		else if (max == r)
			hue = (60 * (g - b) / (max - min) + 360) % 360;
		else if (max == g)
			hue = (60 * (b - r) / (max - min) + 120);
		else if (max == b)
			hue = (60 * (r - g) / (max - min) + 240);

		// get Value
		value = max;

		// get Saturation
		if (max == 0)
			saturation = 0;
		else
			saturation = (max - min) / max;

		return [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
	}

	static public function RGBA2RGB(rgba:RGBA):UInt {
		return (rgba.r << 16) + (rgba.g << 8) + rgba.b;
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
	// static public function hexToRGBA(text:String):RGBA
	// {
	// 	var color:RGBA = new RGBA();
	// 	color.red		= Math.h .parseInt(text.slice(0,2), 16) / 255;
	// 	color.green	= parseInt(text.slice(2,4), 16) / 255;
	// 	color.blue	= parseInt(text.slice(4,6), 16) / 255;
	// 	color.alpha	= parseInt(text.slice(6,8), 16) / 255;
	// 	return color;
	// }

	static public function getExtension(path:String):String {
		var cp = path.lastIndexOf(".");
		if (cp != -1)
			return path.substr(cp + 1);
		return null;
	}
}
