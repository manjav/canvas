package ir.grantech.canvas.controls.groups;

import openfl.events.MouseEvent;
import feathers.controls.Button;
import feathers.layout.HorizontalLayout;
import ir.grantech.canvas.controls.groups.sections.CanSection;

class Header extends CanSection {
	private var menuButton:Button;

	override private function initialize() {
		super.initialize();

		var layout = new HorizontalLayout();
		layout.verticalAlign = MIDDLE;
		this.layout = layout;

		menuButton = this.createButton("zoom", null);
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		trace("menuButton");
	}
}
