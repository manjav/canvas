package ir.grantech.canvas.drawables;

import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;

class CanSlicedBitmap extends Shape implements ICanItem {
	public var layer(default, default):Layer;

	public function new(layer:Layer) {
		super();
		this.layer = layer;
	}

	private function update():Void {}

	private function format():Void {}

	private function draw():Void {
		this.graphics.clear();
		var b:Array<Float> = cast this.layer.getProperty(BOUNDS);
		var sg = new Rectangle(10, 10, b[2] - 20, b[3] - 20);
		var bmp:BitmapData = cast this.layer.getProperty(BITMAP_DATA);
		var cols:Array<Float> = [sg.left, sg.right, b[2]];
		var rows:Array<Float> = [sg.top, sg.bottom, b[3]];
		var left:Float = 0;
		for (i in 0...3) {
			var top:Float = 0;
			for (j in 0...3) {
				trace(left, top, cols[i] - left, rows[j] - top);
				this.graphics.beginBitmapFill(bmp);
				this.graphics.drawRect(left, top, cols[i] - left, rows[j] - top);
				this.graphics.endFill();
				top = rows[j];
			}
			left = cols[i];
		}
		this.scale9Grid = sg;
	}
}
