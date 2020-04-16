package ir.grantech.canvas.controls.groups.panels;

import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.services.Layers.Layer;

class TextPanel extends Panel {
	override private function set_targets(value:CanItems):CanItems {
		super.set_targets(value);
		var isText = value.length == 1 && value.get(0).layer.type == Layer.TYPE_TEXT;
		this.includeInLayout = isText;
		this.visible = isText;
		return value;
	}

	override private function initialize() {
		super.initialize();
		this.title = "TEXT";

		// var layout = new HorizontalLayout();
		// layout.verticalAlign = VerticalAlign.JUSTIFY;
		// layout.gap = layout.paddingLeft = layout.paddingRight = Math.floor(CanTheme.DEFAULT_PADDING * 0.3);
		// this.layout = layout;

		this.height = padding * 10;
	}
}
