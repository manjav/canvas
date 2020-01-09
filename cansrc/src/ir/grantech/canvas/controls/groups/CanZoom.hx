package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;

class CanZoom extends LayoutGroup {
	private var scene:CanScene;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var mask = new Shape();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, 0, 100, 100);
		this.scene.mask = mask;
		this.backgroundSkin = mask;
	}
}
