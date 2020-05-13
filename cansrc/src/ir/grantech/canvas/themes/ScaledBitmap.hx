package ir.grantech.canvas.themes;

import feathers.controls.AssetLoader;

class ScaledBitmap extends AssetLoader {
	public function new(source:String) {
		super();
		this.source = "assets/img/" + CanTheme.DPI + "x/" + source + ".png";
	}
}
