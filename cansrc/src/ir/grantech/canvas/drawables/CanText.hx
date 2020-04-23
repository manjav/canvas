package ir.grantech.canvas.drawables;

import ir.grantech.canvas.services.Layers.Layer;
import openfl.text.TextField;

class CanText extends TextField implements ICanItem {
	public var layer(default, default):Layer;

	private function update():Void {}
}
