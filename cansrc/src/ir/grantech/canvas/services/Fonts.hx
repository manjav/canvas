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

		var ret = new Array<FontFamily>();
		var family:FontFamily = new FontFamily(fonts[0]);
		ret.push(family);
		for (i in 1...fonts.length) {
			if (fonts[i].fontName.indexOf(family.name) > -1) {
				family.addStyle(fonts[i], fonts[i].fontName.substr(family.name.length + 1));
				continue;
			}
			family = new FontFamily(fonts[i]);
			ret.push(family);
		}
		return ret;
	}
}

// Typesettg Bold Italic Black Fixed Semibold Semilight Light Emoji Negreta Cursiva Historic

class FontFamily {

	public var name:String;
	public var styles:Array<Font>;
	public var styleNames:Array<String>;

	public function new(font:Font) {
		this.name = font.fontName;
		this.styles = new Array<Font>();
    this.styleNames = new Array<String>();
    this.addStyle(font, "Regular");
  }
  
  public function addStyle(font:Font, name:String):Void{
		this.styles.push(font);
    this.styleNames.push(name); 
  }
}
