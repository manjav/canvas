package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.CanHSlider;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;

class AppearPanel extends Panel {
	private var alphaSlider:CanHSlider;

	override private function initialize() {
		this.height = 64 * CanTheme.DPI;
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "APPEARANCE";

		this.createLabel("Opacity", AnchorLayoutData.topLeft(padding * 4, padding));
		this.alphaSlider = this.createSlider(0, 100, 100, new AnchorLayoutData(padding * 5.5, padding, null, padding));

		this.createLabel("Blend Mode", AnchorLayoutData.topLeft(padding * 9, padding));
	}

	override private function sliders_changeHandler(event:Event) {
		if (this.inputService.selectedItem != null)
			this.inputService.selectedItem.alpha = this.alphaSlider.value * 0.01;
	}

	public function updateData():Void {
		if (this.inputService.selectedItem == null)
			return;
		this.alphaSlider.value = this.inputService.selectedItem.alpha * 100;
	}
}
