package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.controls.groups.panels.TransformPanel;

class RightBar extends VGroup {
	private var transfromPanel:TransformPanel;

	override private function initialize() {
		super.initialize();

		this.transfromPanel = new TransformPanel();
		this.addChild(this.transfromPanel);
	}
}
