package ir.grantech.canvas.drawables;

import openfl.events.Event;
import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;

class CanText extends TextField implements ICanItem {
	public var layer(default, default):Layer;

	public function new(layer:Layer) {
		super();
		this.layer = layer;
		this.addEventListener(Event.CHANGE, this.changeHandler);
	}

	private function changeHandler(event:Event):Void {
		this.layer.setProperty(TEXT, this.text);
	}

	private function update():Void {
		if (this.layer.isInvalid(TEXT_AUTOSIZE)) {
			var autoSize = TextFieldAutoSize.NONE;
			if (this.layer.getInt(TEXT_AUTOSIZE) == 0) {
				autoSize = switch (this.getTextFormat().align) {
					case TextFormatAlign.CENTER: TextFieldAutoSize.CENTER;
					case TextFormatAlign.RIGHT: TextFieldAutoSize.RIGHT;
					default: TextFieldAutoSize.LEFT;
				}
			}
			this.autoSize = autoSize;
		}
	}

	private function format():Void {
		var tf = this.getTextFormat();
		tf.align = cast(this.layer.getProperty(TEXT_ALIGN), TextFormatAlign);
		tf.color = this.layer.getInt(TEXT_COLOR);
		tf.font = this.layer.getString(TEXT_FONT);
		tf.letterSpacing = this.layer.getInt(TEXT_LETTERPACE);
		tf.leading = this.layer.getInt(TEXT_LINESPACE);
		tf.size = this.layer.getInt(TEXT_SIZE);
		this.setTextFormat(tf);
	}

	private function draw():Void {
		this.background = this.layer.getBool(FILL_ENABLED);
		if (this.background)
			this.backgroundColor = this.layer.getUInt(FILL_COLOR);
		this.border = this.layer.getBool(BORDER_ENABLED);
		if (this.border)
			this.borderColor = this.layer.getUInt(BORDER_COLOR);
	}
}
