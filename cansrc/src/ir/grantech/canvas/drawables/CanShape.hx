package ir.grantech.canvas.drawables;

import feathers.core.InvalidationFlag;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.Shape;

class CanShape extends Shape implements ICanItem {
	public var layer(default, default):Layer;

	public function new(layer:Layer) {
		super();
		this.layer = layer;
	}

	private function update():Void {
		if (this.layer.isInvalid(InvalidationFlag.STYLES))
			this.draw();
	}

	public function draw():Void {
		this.graphics.clear();
		if (!this.layer.fillEnabled && !this.layer.borderEnabled)
			return;
		if (this.layer.fillEnabled)
			this.graphics.beginFill(this.layer.fillColor, this.layer.fillAlpha);
		if (this.layer.borderEnabled)
			this.graphics.lineStyle(this.layer.borderSize, this.layer.borderColor, this.layer.borderAlpha);

		if (this.layer.type == Layer.TYPE_RECT)
			this.graphics.drawRoundRect(0, 0, this.layer.initialWidth, this.layer.initialHeight, this.layer.cornerRadius, this.layer.cornerRadius);
		else
			this.graphics.drawEllipse(0, 0, this.layer.initialWidth, this.layer.initialHeight);

		this.graphics.endFill();
	}
}
