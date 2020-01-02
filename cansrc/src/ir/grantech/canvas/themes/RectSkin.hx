package ir.grantech.canvas.themes;

import feathers.skins.RectangleSkin;

class RectSkin extends RectangleSkin {
	override public function drawPath() {
		var currentBorder = this.getCurrentBorder();
		var padding = 4;
		var thickness = getLineThickness(currentBorder) + padding * 2;
		var thicknessOffset = thickness / 2.0;

		if (this.cornerRadius == 0.0 || this.cornerRadius == null) {
			this.graphics.drawRect(thicknessOffset, thicknessOffset, this.actualWidth - thickness, this.actualHeight - thickness);
		} else {
			this.graphics.drawRoundRect(thicknessOffset, thicknessOffset, this.actualWidth - thickness, this.actualHeight - thickness, this.cornerRadius,
				this.cornerRadius);
		}
	}
}
