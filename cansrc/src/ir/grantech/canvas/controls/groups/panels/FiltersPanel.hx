package ir.grantech.canvas.controls.groups.panels;

import feathers.layout.AnchorLayout;

class FiltersPanel extends Panel {
	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "FILTERS";
	}
}
