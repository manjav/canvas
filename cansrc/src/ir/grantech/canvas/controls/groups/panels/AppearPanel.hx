package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.CanHSlider;
import feathers.controls.PopUpListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.events.Event;

class AppearPanel extends Panel {
	private var alphaSlider:CanHSlider;
	private var modesList:PopUpListView;

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "APPEARANCE";

		// Opacity
		this.createLabel("Opacity", AnchorLayoutData.topLeft(padding * 4, padding));

		this.alphaSlider = this.createSlider(0, 100, 100, new AnchorLayoutData(padding * 5.5, padding, null, padding));

		// Blend Mode
		this.createLabel("Blend Mode", AnchorLayoutData.topLeft(padding * 9, padding));

		var modes = [
			"add", "alpha", "darken", "difference", "erase", "hardlight", "invert", "layer", "lighten", "multiply", "normal", "overlay", "screen", "shader",
			"subtract"
		];
		this.modesList = this.createPopupList(modes, new AnchorLayoutData(padding * 10.7, padding, null, padding));
		this.modesList.itemToText = (item:String) -> {
			return item.substr(0, 1).toUpperCase() + item.substr(1);
		};

		this.height = padding * 15;
	}

	override private function sliders_changeHandler(event:Event) {
		if (this.inputs.selectedItem != null)
			this.inputs.selectedItem.alpha = this.alphaSlider.value * 0.01;
	}

	override private function popupListView_changeHandler(event:Event) {
		if (this.inputs.selectedItem != null)
			this.inputs.selectedItem.blendMode = this.modesList.selectedItem;
	}

	public function updateData():Void {
		if (this.inputs.selectedItem == null)
			return;
		this.alphaSlider.value = this.inputs.selectedItem.alpha * 100;
		this.modesList.selectedItem = this.inputs.selectedItem.blendMode;
	}
}
