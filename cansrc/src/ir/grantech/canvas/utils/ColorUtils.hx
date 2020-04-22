package ir.grantech.canvas.utils;

import lime.math.RGB;

class ColorUtils {
	/**
	 * Converts HSV values to RGB values.
	 * @param h: A uint from 0 to 360 representing the hue value.
	 * @param s: A uint from 0 to 100 representing the saturation value.
	 * @param v: A uint from 0 to 100 representing the lightness value.
	 * @return Returns an object with the properties r, g, and b defined.
	 */
	static public function HSV2RGB(h:Float, s:Float, v:Float):RGB {
		var r:Float = 0;
		var g:Float = 0;
		var b:Float = 0;
		var tempS:Float = s / 100;
		var tempV:Float = v / 100;
		var hi:Int = Math.floor(h / 60) % 6;
		var f:Float = h / 60 - Math.floor(h / 60);
		var p:Float = (tempV * (1 - tempS));
		var q:Float = (tempV * (1 - f * tempS));
		var t:Float = (tempV * (1 - (1 - f) * tempS));

		switch (hi) {
			case 0:
				r = tempV;
				g = t;
				b = p;
			case 1:
				r = q;
				g = tempV;
				b = p;
			case 2:
				r = p;
				g = tempV;
				b = t;
			case 3:
				r = p;
				g = q;
				b = tempV;
			case 4:
				r = t;
				g = p;
				b = tempV;
			case 5:
				r = tempV;
				g = p;
				b = q;
		}
		var rgb:RGB = new RGB();
		rgb.set(Math.round(r * 255), Math.round(g * 255), Math.round(b * 255));
		return rgb;
	}

	/**
	 * Converts RGB values to HSV values.
	 * @param r: A uint from 0 to 255 representing the red color value.
	 * @param g: A uint from 0 to 255 representing the green color value.
	 * @param b: A uint from 0 to 255 representing the blue color value.
	 * @return Returns an object with the properties h, s, and v defined.
	 */
	static public function RGB2HSV(r:Float, g:Float, b:Float):Array<UInt> {
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

	// static public function RGBA2RGB(rgba:RGBA):UInt {
	// 	return (rgba.r << 16) + (rgba.g << 8) + rgba.b;
	// }
}
