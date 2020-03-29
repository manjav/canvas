package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.CanTextInput;
import feathers.layout.AnchorLayout;
import ir.grantech.canvas.themes.CanTheme;

class TransformPanel extends Panel {
	private var inputX:CanTextInput;
	private var inputY:CanTextInput;
	private var inputW:CanTextInput;
	private var inputH:CanTextInput;

	override private function initialize() {
		this.height = 240 * CanTheme.DPI;
		super.initialize();

		var padding = CanTheme.DPI * 7;
		this.layout = new AnchorLayout();
		this.inputX = this.createInput(padding * 1, null, null, padding * 1, 0);
		this.inputY = this.createInput(padding * 3, null, null, padding * 1, 1);
		this.inputW = this.createInput(padding * 1, null, null, padding * 8, 2);
		this.inputH = this.createInput(padding * 3, null, null, padding * 8, 3);
	}
}
