package ir.grantech.canvas.controls.groups.sections;

import feathers.layout.AnchorLayout;

class FiltersSection extends CanSection {
	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "FILTERS";
	}
}
