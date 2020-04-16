package ir.grantech.canvas.controls.groups.panels;

import openfl.display.BlendMode;
import feathers.controls.CanHSlider;
import feathers.controls.PopUpListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.services.Commands;
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
		var names = [
			"Normal", "Overlay", "screen", "multiply", "add", "alpha", "lighten", "darken", "difference", "erase", "hardlight", "invert", "layer", "shader",
			"subtract"
		];

		var modes = [
			BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.MULTIPLY, BlendMode.ADD, BlendMode.ALPHA, BlendMode.LIGHTEN, BlendMode.DARKEN,
			BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.SHADER, BlendMode.SUBTRACT
		];

		var data = [];
		for(i in 0...modes.length)
			data.push({text:names[i], value:modes[i]});
		this.modesList = this.createPopupList(data, new AnchorLayoutData(padding * 10.7, padding, null, padding));
		this.modesList.itemToText = (item:Dynamic) -> {
			return item.text;
		};

		this.height = padding * 15;
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
		this.updating = false;
	}

	private function findBlendMode(blendMode:BlendMode):Int{
		for (i in 0...this.modesList.dataProvider.length)
			if( this.modesList.dataProvider.get(i).value == blendMode)
				return i;	
		return -1;
	}
}
