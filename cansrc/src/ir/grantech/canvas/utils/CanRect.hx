package ir.grantech.canvas.utils;

import openfl.geom.Rectangle;

class CanRect extends Rectangle {
	public var center(get, never):Float;

	private function get_center():Float {
		return this.x + this.width * 0.5;
	}

	public var middle(get, never):Float;

	private function get_middle():Float {
		return this.y + this.height * 0.5;
	}
}
