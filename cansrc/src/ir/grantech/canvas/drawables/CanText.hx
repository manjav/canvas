package ir.grantech.canvas.drawables;

import feathers.core.InvalidationFlag;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.text.TextField;

class CanText extends TextField implements ICanItem {
	public var layer(default, default):Layer;

	public function new(layer:Layer) {
		super();
		this.layer = layer;
	}

	private function update():Void {
		if (this.layer.isInvalid(InvalidationFlag.STYLES))
			this.draw();
		if (this.layer.isInvalid(InvalidationFlag.SKIN))
			this.format();
	}

	public function format():Void {
		this.setTextFormat(this.layer.textFormat);
	}

	public function draw():Void {
		this.background = this.layer.fillEnabled;
		if (this.layer.fillEnabled)
			this.backgroundColor = this.layer.fillColor;
		this.border = this.layer.borderEnabled;
		if (this.layer.borderEnabled)
			this.borderColor = this.layer.borderColor;
	}
}
