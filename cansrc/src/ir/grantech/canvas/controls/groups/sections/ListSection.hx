package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.themes.CanTheme;

class ListSection extends CanSection {
	private var searchInput:CanTextInput;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();
		this.padding = CanTheme.DPI * 7;

		this.searchInput = createTextInput("toolhead_7", new AnchorLayoutData(this.padding * 3, this.padding, null, this.padding));
	}
}
