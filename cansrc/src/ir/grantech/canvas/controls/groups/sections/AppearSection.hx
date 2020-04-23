package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.CanHSlider;
import feathers.controls.PopUpListView;
import feathers.controls.colors.ColorLine;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.services.Commands;
import openfl.display.BlendMode;
import openfl.events.Event;

class AppearSection extends CanSection {
	private var alphaSlider:CanHSlider;
	private var modesList:PopUpListView;
	private var fillPicker:ColorLine;
	private var borderPicker:ColorLine;

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "APPEARANCE";

		// Opacity
		this.createLabel("Opacity", AnchorLayoutData.topLeft(padding * 4, padding));

		this.alphaSlider = this.createSlider(0, 100, 100, new AnchorLayoutData(padding * 5.5, padding, null, padding));

		// Blend Mode
		this.createLabel("Blend Mode", AnchorLayoutData.topLeft(padding * 9, padding));
		var names = [
			"Normal", "Overlay", "Screen", "Multiply", "Add", "Alpha", "Lighten", "Darken", "Difference", "Erase", "Hardlight", "Invert", "Layer", "Shader",
			"Subtract"
		];

		var modes = [
			BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.MULTIPLY, BlendMode.ADD, BlendMode.ALPHA, BlendMode.LIGHTEN, BlendMode.DARKEN,
			BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.SHADER, BlendMode.SUBTRACT
		];

		var data = [];
		for (i in 0...modes.length)
			data.push({text: names[i], value: modes[i]});
		this.modesList = this.createPopupList(data, new AnchorLayoutData(padding * 10.7, padding, null, padding));
		this.modesList.itemToText = (item:Dynamic) -> {
			return item.text;
		};

		this.fillPicker = this.createColorLine("Fill", 0, 1, true, new AnchorLayoutData(padding * 15, padding, null, padding));
		this.borderPicker = this.createColorLine("Border", 0, 1, false, new AnchorLayoutData(padding * 18, padding, null, padding));

		this.height = padding * 21;
	}

	override private function sliders_changeHandler(event:Event) {
		if (!this.updating && this.targets != null)
			commands.commit(Commands.ALPHA, [this.targets, this.alphaSlider.value * 0.01]);
	}

	override private function popupListView_changeHandler(event:Event) {
		if (!this.updating && this.targets != null)
			commands.commit(Commands.BLEND_MODE, [this.targets, this.modesList.selectedItem.value]);
	}

	override public function updateData():Void {
		if (this.targets == null || !this.targets.filled)
			return;
		this.updating = true;
		this.alphaSlider.value = this.targets.length == 1 ? this.targets.get(0).alpha * 100 : 100;
		this.modesList.selectedIndex = this.findBlendMode(this.targets.blendMode);
		this.fillPicker.rgb = this.targets.fillColor;
		this.fillPicker.a = Math.round(this.targets.fillAlpha * 0xFF);
		this.updating = false;
	}

	private function findBlendMode(blendMode:BlendMode):Int {
		for (i in 0...this.modesList.dataProvider.length)
			if (this.modesList.dataProvider.get(i).value == blendMode)
				return i;
		return -1;
	}
}
