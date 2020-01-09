package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;

class CanZoom extends LayoutGroup {
	private var scene:CanScene;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);
	}
}
