package ir.grantech.canvas.drawables;

import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.Shape;

class CanShape extends Shape implements ICanItem {
	public var layer(default, default):Layer;

	public function new(layer:Layer) {
		super();
		this.layer = layer;
	}

	private function update():Void {}

	private function format():Void {}

	private function draw():Void {
		this.graphics.clear();
		if (!this.layer.getBool(FILL_ENABLE) && !this.layer.getBool(BORDER_ENABLE))
			return;
		if (this.layer.getBool(FILL_ENABLE))
			this.graphics.beginFill(this.layer.getUInt(FILL_COLOR), this.layer.getFloat(FILL_ALPHA));
		if (this.layer.getBool(BORDER_ENABLE))
			this.graphics.lineStyle(this.layer.getFloat(BORDER_SIZE), this.layer.getUInt(BORDER_COLOR), this.layer.getFloat(BORDER_ALPHA));

		var b:Array<Float> = cast this.layer.getProperty(BOUNDS);
		if (this.layer.getString(TYPE) == Layer.TYPE_RECT)
			this.graphics.drawRoundRect(0, 0, b[2], b[3], this.layer.getFloat(CORNER_RADIUS), this.layer.getFloat(CORNER_RADIUS));
		else
			this.graphics.drawEllipse(0, 0, b[2], b[3]);

		this.graphics.endFill();
	}
}
