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
	}
}
