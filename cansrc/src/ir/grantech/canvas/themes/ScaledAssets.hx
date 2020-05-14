package ir.grantech.canvas.themes;

import lime.app.Future;
import openfl.Assets;
import openfl.display.BitmapData;

class ScaledAssets {
	public static function getBitmapData(id:String, useCache:Bool = true) {
		return Assets.getBitmapData("assets/img/" + CanTheme.DPI + "x/" + id, useCache);
	}

	public static function loadBitmapData(id:String, useCache:Null<Bool> = true):Future<BitmapData> {
		return Assets.loadBitmapData("assets/img/" + CanTheme.DPI + "x/" + id + ".png", useCache);
	}
}
