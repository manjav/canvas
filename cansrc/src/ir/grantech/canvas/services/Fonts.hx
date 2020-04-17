package ir.grantech.canvas.services;

import ir.grantech.canvas.utils.Utils;
import openfl.text.Font;

class Fonts {
	static public function load():Array<FontFamily> {
		var fonts:Array<Font> = Font.enumerateFonts(true);
	}
}
