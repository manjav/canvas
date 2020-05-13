package ir.grantech.canvas.themes;

import feathers.events.FeathersEvent;
import feathers.core.FeathersControl;
import feathers.controls.AssetLoader;

class ScaledBitmap extends AssetLoader {
	public function new(source:String) {
		super();
		this.source = "assets/img/" + CanTheme.DPI + "x/" + source + ".png";
	}

	override private function layoutChildren():Void {
		super.layoutChildren();
		FeathersEvent.dispatch(this, FeathersEvent.LAYOUT_DATA_CHANGE);
	}
}
