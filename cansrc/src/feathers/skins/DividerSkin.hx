/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.skins;

import feathers.graphics.LineStyle;
import feathers.graphics.FillStyle;

/**
	A skin for Feathers UI components that draws a border at the bottom only.

	@since 1.0.0
**/
class DividerSkin extends BaseGraphicsPathSkin {
	private var padding:Float = 0;

	/**
		Creates a new `DividerSkin` object.
		@since 1.0.0
	**/
	public function new(padding:Float = 0) {
		super();
		this.padding = padding;
	}

	override private function draw():Void {
		var currentBorder = this.getCurrentBorder();
		var currentFill = this.getCurrentFill();
		if (currentFill != null) {
			this.applyFillStyle(currentFill);
			this.graphics.drawRect(0.0, 0.0, this.actualWidth, this.actualHeight);
			this.graphics.endFill();
		}
		this.applyLineStyle(currentBorder);
		this.graphics.moveTo(this.padding, this.actualHeight * 0.5);
		this.graphics.lineTo(this.actualWidth - this.padding * 2, this.actualHeight * 0.5);
	}
}
