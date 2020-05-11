package ir.grantech.canvas.services;

import ir.grantech.canvas.utils.StringUtils;
import openfl.text.Font;

class Fonts {
	static public function load():Array<FontFamily> {
		var fonts:Array<Font> = Font.enumerateFonts(true);
		#if !(flash || html5)
		var fontsPath = lime.system.System.fontsDirectory.toLowerCase();
		var index = fontsPath.lastIndexOf("fonts");
		if (fontsPath.substr(index) != "fonts\\")
			fontsPath = fontsPath.substr(0, index) + "fonts\\";
		var dir = sys.FileSystem.readDirectory(fontsPath);
		for (f in dir)
			if (StringUtils.getExtension(f) == "ttf")
				fonts.push(Font.fromFile(fontsPath + f));
		#end

		var ret = new Array<FontFamily>();
		var family:FontFamily = new FontFamily(fonts[0]);
		ret.push(family);
		for (i in 1...fonts.length) {
			if (fonts[i].fontName.indexOf(family.name) > -1) {
				family.styles.push(new FontStyle(fonts[i], family, fonts[i].fontName.substr(family.name.length + 1)));
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
	public var styles:Array<FontStyle>;

	public function new(font:Font) {
		this.name = font.fontName;
		this.styles = new Array<FontStyle>();
		this.styles.push(new FontStyle(font, this, "Regular"));
	}

	static public function findByStyle(families:Array<FontFamily>, style:String):FontStyle {
		for (f in families)
			for (s in f.styles)
				if (s.font.fontName == style)
					return s;
		return null;
	}
}

class FontStyle {
	public var font:Font;
	public var family:FontFamily;
	public var styleName:String;

	public var fontName(get, never):String;

	private function get_fontName():String {
		#if flash
		return font.fontName;
		#else
		return font.name;
		#end
	}

	public function new(font:Font, family:FontFamily, styleName:String) {
		this.font = font;
		this.family = family;
		this.styleName = styleName;
	}
}
