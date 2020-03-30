package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.CanTextInput;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.themes.CanTheme;

class ListPanel extends Panel {
	public var title:String = "No title";

	private var searchInput:CanTextInput;
	private var titleDisplay:Label;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();
		this.padding = CanTheme.DPI * 7;

		this.titleDisplay = new Label();
		this.titleDisplay.variant = Label.VARIANT_HEADING;
		this.titleDisplay.text = this.title;
		this.titleDisplay.layoutData = AnchorLayoutData.topLeft(this.padding, this.padding);
		this.addChild(this.titleDisplay);

		this.searchInput = createTextInput("toolhead_7", new AnchorLayoutData(this.padding * 3, this.padding, null, this.padding));
	}
}
