package ir.grantech.canvas.services;

import ir.grantech.canvas.utils.Utils;
import openfl.text.Font;

class Fonts {
	static public function load():Array<FontFamily> {
		var fonts:Array<Font> = Font.enumerateFonts(true);
		#if !(flash || html5)
		fonts = new Array<Font>();
		var fontsPath = lime.system.System.fontsDirectory.toLowerCase();
		var index = fontsPath.lastIndexOf("fonts");
		if (fontsPath.substr(index) != "fonts\\")
			fontsPath = fontsPath.substr(0, index) + "fonts\\";
		var dir = sys.FileSystem.readDirectory(fontsPath);
		for (f in dir)
			if (Utils.getExtension(f) == "ttf")
				fonts.push(Font.fromFile(fontsPath + f));
		#end

	}
}
