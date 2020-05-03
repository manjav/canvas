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
		if (!this.layer.getBool(FILL_ENABLED) && !this.layer.getBool(BORDER_ENABLED))
			return;
		if (this.layer.getBool(FILL_ENABLED))
			this.graphics.beginFill(this.layer.getUInt(FILL_COLOR), this.layer.getFloat(FILL_ALPHA));
		if (this.layer.getBool(BORDER_ENABLED))
			this.graphics.lineStyle(this.layer.getFloat(BORDER_SIZE), this.layer.getUInt(BORDER_COLOR), this.layer.getFloat(BORDER_ALPHA));

		if (this.layer.type == Layer.TYPE_RECT)
			this.graphics.drawRoundRect(0, 0, this.layer.initialWidth, this.layer.initialHeight, this.layer.getFloat(CORNER_RADIUS),
				this.layer.getFloat(CORNER_RADIUS));
		else
			this.graphics.drawEllipse(0, 0, this.layer.initialWidth, this.layer.initialHeight);

		this.graphics.endFill();
	}
}
