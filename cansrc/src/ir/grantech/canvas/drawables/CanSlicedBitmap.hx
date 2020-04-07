package ir.grantech.canvas.drawables;

import openfl.geom.Rectangle;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.BitmapData;
import openfl.display.Shape;

class CanSlicedBitmap extends Shape implements ICanItem {
  public var layer(default, default):Layer;
  public function new(bitmapData:BitmapData, scale9Grid:Rectangle) {
    super();

    var cols:Array<Float> = [scale9Grid.left, scale9Grid.right, bitmapData.width];
		var rows:Array<Float> = [scale9Grid.top, scale9Grid.bottom, bitmapData.height];
		var left:Float = 0;
		for (i in 0...3) {
			var top:Float = 0;
			for (j in 0...3) {
				this.graphics.beginBitmapFill(bitmapData);
				this.graphics.drawRect(left, top, cols[i] - left, rows[j] - top);
				this.graphics.endFill();
				top = rows[j];
			}
			left = cols[i];
    }
    this.scale9Grid = scale9Grid;
  }
}