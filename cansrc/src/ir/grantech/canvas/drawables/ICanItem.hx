package ir.grantech.canvas.drawables;

import feathers.core.IDisplayObject;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Rectangle;
import openfl.geom.Transform;

interface ICanItem extends IDisplayObject {
	public var layer(default, default):Layer;

	#if flash
	public var rotation:Float;
	#else
	public var rotation(get, set):Float;
	#end

	#if flash
	public var transform:Transform;
	#else
	public var transform(get, set):Transform;
	#end

	#if flash
	public var blendMode:BlendMode;
	#else
	public var blendMode(get, set):BlendMode;
	#end

	public var parent(default, never):DisplayObjectContainer;
	
	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
}
